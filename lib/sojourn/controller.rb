require_relative 'tracker'

module Sojourn
  module Controller
    def self.included(base)
      base.before_filter :track_sojourning
      base.before_filter :save_sojourn_session
    end

    def sojourn
      @sojourn ||= Tracker.new(self)
    end

  private

    def track_sojourning
      sojourn.sojourning!
    end

    def save_sojourn_session
      sojourn.update_session!
    end
  end
end
