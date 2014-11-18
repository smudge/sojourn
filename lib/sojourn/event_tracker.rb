require_relative 'event'
module Sojourn
  class EventTracker

    attr_accessor :request, :current_visit

    def initialize(request, current_visit = nil)
      self.request = request
      self.current_visit = current_visit
    end

    def track!(event_name, properties = {}, time = Time.now)
      Event.create! name: event_name,
                    request: request,
                    visit: current_visit,
                    properties: properties,
                    created_at: time
    end

  end
end
