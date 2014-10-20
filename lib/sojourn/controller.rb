require_relative 'tracker'
module Sojourn
  module Controller

    def self.included(base)
      base.before_filter :track_sojourner
    end

    def current_visit
      @current_visit ||= sojourn_tracker.current_visit
    end

    def current_visitor
      @current_visitor ||= sojourn_tracker.current_visitor
    end

    def track_sojourner
      sojourn_tracker.track!
    end

  private

    def sojourn_tracker
      @sojourn_tracker ||= Tracker.new(request, session, current_user)
    end

  end
end
