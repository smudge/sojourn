require_relative 'event'
module Sojourn
  class EventTracker

    attr_accessor :current_visit

    def initialize(current_visit = nil)
      self.current_visit = current_visit
    end

    def track!(event_name, properties = {})
      Event.create!(name: event_name, visit: current_visit, properties: properties)
    end

  end
end
