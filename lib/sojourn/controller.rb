module Sojourn
  module Controller

    def self.included(base)
      base.before_filter :current_visit
    end

    def current_visit
      @current_visit ||= current_visitor.visits.last
      @current_visit ||= Visit.create_from_request!(request, current_visitor)
    end

    def current_visitor
      @current_visitor ||= Visitor.find_from_session(session, current_user)
      @current_visitor ||= Visitor.create_from_request!(request, session, current_user)
    end

  end
end
