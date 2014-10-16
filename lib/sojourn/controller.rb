module Sojourn
  module Controller

    def self.included(base)
      base.before_filter :track_sojourner
    end

    def current_visit
      @current_visit ||= Visit.find_from_request(request, current_visitor)
      @current_visit ||= Visit.create_from_request!(request, current_visitor)
    end

    def current_visitor
      @current_visitor ||= Visitor.find_from_session(session, current_user)
      @current_visitor ||= Visitor.create_from_request!(request, session, current_user)
    end

    def track_sojourner
      current_visit.update_column(:last_active_at, Time.now)
    end

  end
end
