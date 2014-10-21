require_relative 'visit_tracker'
require_relative 'event_tracker'

module Sojourn
  module Controller

    def self.included(base)
      base.before_filter :track_sojourn_visit
    end

    def current_visit
      @current_visit ||= sojourn_visit_tracker.current_visit
    end

    def current_visitor
      @current_visitor ||= sojourn_visit_tracker.current_visitor
    end

    def track_sojourn_visit
      sojourn_visit_tracker.track!
    end

    def sojourn
      @sojourn ||= EventTracker.new(current_visit)
    end

  private

    def sojourn_visit_tracker
      @sojourn_tracker ||= VisitTracker.new(request, session, current_user)
    end

  end
end
