module Sojourn
  module Controller

    def self.included(base)
      base.before_filter :track_sojourner
    end

    def current_visit
      @current_visit ||= Visit.find_from_request(request, current_visitor)
    end

    def current_visitor
      @current_visitor ||= Visitor.find_from_uuid(session[:sojourner_visitor_uuid], current_user)
    end

    def track_sojourner
      return if Sojourn.bot?(request)
      if session[:sojourner_visitor_uuid].blank? || session[:sojourner_last_active_at] < 1.week.ago
        @current_visitor = Visitor.create_from_request!(request, current_user)
        session[:sojourner_visitor_uuid] = @current_visitor.uuid
        session[:sojourner_current_user_id] = current_user.try(:id)
      elsif current_user.try(:id) != session[:sojourner_current_user_id]
        if session[:sojourner_current_user_id].blank?
          session[:sojourner_current_user_id] = current_user.try(:id)
          current_visitor.update_attributes(user_id: current_user.try(:id))
        else
          @current_visitor = Visitor.create_from_request!(request, current_user)
          session[:sojourner_visitor_uuid] = @current_visitor.uuid
          session[:sojourner_current_user_id] = current_user.try(:id)
          session[:sojourner_visit_uuid] = nil
          session[:sojourner_last_active_at] = nil
        end
      end
      if session[:sojourner_visit_uuid].blank? || session[:sojourner_last_active_at] < 1.day.ago
        @current_visit = Visit.create_from_request!(request, current_visitor)
        session[:sojourner_visit_uuid] = @current_visit.uuid
      end
      session[:sojourner_last_active_at] = Time.now
    end

  private

    def with_user(visitor, session, user)
      return visitor if visitor.nil? || visitor.user_id == user.try(:id)
      visitor.update_attributes(user: user) and return visitor if user && visitor.user_id.nil?
      session[:visitor_uuid] = nil
    end

  end
end
