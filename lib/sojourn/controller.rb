module Sojourn
  module Controller

    def self.included(base)
      base.before_filter :track_sojourn_visit
    end

    def track_sojourn_visit
      Visit.create_from_request!(request, current_visitor) if current_visitor.visits.empty?
    end

    def current_visitor
      if session[:visitor_uuid].nil?
        @current_visitor = Visitor.create_from_request!(request, current_user)
        session[:visitor_uuid] = @current_visitor.uuid
      else
        @current_visitor ||= Visitor.find_by_uuid!(session[:visitor_uuid])
      end
      @current_visitor
    end

  end
end
