module Sojourn
  module Controller

    def self.included(base)
      base.before_filter :check_sojourn_user
      base.before_filter :track_sojourn_visit
    end

    def track_sojourn_visit
      Visit.create_from_request!(request, current_visitor) if current_visitor.visits.empty?
    end

    def check_sojourn_user
      return if current_visitor.user_id == current_user.try(:id)
      if current_visitor.user_id.nil?
        current_visitor.update_attribute(:user, current_user)
      else
        clear_current_visitor
      end
    end

    def current_visitor
      if session[:visitor_uuid]
        @current_visitor = Visitor.where(uuid: session[:visitor_uuid]).unexpired.last
      end
      unless @current_visitor
        @current_visitor = Visitor.create_from_request!(request, current_user)
        session[:visitor_uuid] = @current_visitor.uuid
      end
      @current_visitor
    end

    def clear_current_visitor
      @current_visitor = nil
      session[:visitor_uuid] = nil
    end

  end
end
