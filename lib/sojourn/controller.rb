require_relative 'tracker'

module Sojourn
  module Controller

    def self.included(base)
      base.before_filter :track_sojourning
    end

    def sojourn
      @sojourn ||= Tracker.new(request, session, current_user)
    end

  private

    def track_sojourning
      sojourn.sojourning!
    end

  end
end
