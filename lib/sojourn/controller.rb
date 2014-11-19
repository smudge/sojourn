require_relative 'tracker'
require_relative 'request'

module Sojourn
  module Controller

    def self.included(base)
      base.before_filter :track_sojourn_request
    end

    def current_visit
      @current_visit ||= sojourn.current_visit
    end

    def current_visitor
      @current_visitor ||= sojourn.current_visitor
    end

    def sojourn
      @sojourn ||= Tracker.new(request, session, current_user)
    end

  private

    def track_sojourn_request
      sojourn.track_request!
    end

  end
end
