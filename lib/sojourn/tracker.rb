require_relative 'request'
require_relative 'event'

module Sojourn
  class Tracker
    attr_accessor :request, :session, :current_user

    def initialize(request, session, current_user = nil)
      self.request, self.session, self.current_user, @now =
        Request.from_request(request), session, current_user, Time.now
    end

    def track!(event_name, properties = {}, user_id = current_user_id)
      Event.create! sojourner_uuid: sojourner_uuid, name: event_name, request: request,
                    properties: properties, user_id: user_id
    end

    def sojourning!
      track!('!sojourning') if sojourning?
      track_user_change! if user_changed?
      update_session!
    end

    def track_user_change!
      return unless user_changed?
      track!('!logged_out', {}, tracked_user_id) if tracked_user_id
      track!('!logged_in', {}, current_user_id) if current_user_id
    end

    def update_session!
      session[:sojourner_uuid] ||= sojourner_uuid
      session[:sojourn_user_id] = current_user_id
    end

  private

    def sojourner_uuid
      @sojourner_uuid ||= session[:sojourner_uuid] || SecureRandom.uuid
    end

    def sojourning?
      request.outside_referer? || request.any_utm_data? || new_sojourner?
    end

    def new_sojourner?
      !session.include?(:sojourner_uuid)
    end

    # Current User Tracking:

    def user_changed?
      user_tracked? && tracked_user_id != current_user_id
    end

    def user_tracked?
      session.include?(:sojourn_user_id)
    end

    def current_user_id
      current_user.try(:id)
    end

    def tracked_user_id
      session[:sojourn_user_id]
    end
  end
end
