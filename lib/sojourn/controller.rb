require_relative 'tracker'

module Sojourn
  module Controller
    def self.included(base)
      callback = base.respond_to?(:before_action) ? :before_action : :before_filter
      base.public_send callback, :track_sojourning
      base.public_send callback, :save_sojourn_session
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
