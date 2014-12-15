require_relative 'request'
require_relative 'event'

module Sojourn
  class Tracker
    attr_accessor :ctx
    delegate :current_user, to: :ctx

    def initialize(ctx)
      self.ctx = ctx
    end

    def track!(event_name, properties = {}, user_id = current_user_id)
      return unless Sojourn.tables_exist?
      properties = default_event_properties.merge(properties)
      Event.create! sojourner_uuid: sojourner_uuid, name: event_name, request: request,
                    properties: properties, user_id: user_id
    end

    def sojourning!
      return unless Sojourn.config.tracking_enabled && Sojourn.tables_exist?
      track!('!sojourning') if sojourning?
      track_user_change! if user_changed?
    end

    def track_user_change!
      return unless user_changed?
      track!('!logged_out', {}, session.user_id) if session.user_id
      track!('!logged_in', {}, current_user_id) if current_user_id
    end

    def update_session!
      session.sojourner_uuid ||= sojourner_uuid
      session.user_id = current_user_id
    end

  private

    def request
      @request ||= Request.from_request(ctx.request)
    end

    def session
      @session ||= Sojourn.config.session_store.new(ctx)
    end

    def sojourner_uuid
      @sojourner_uuid ||= session.sojourner_uuid || SecureRandom.uuid
    end

    def sojourning?
      request.outside_referer? || request.any_utm_data? || !session.sojourner_tracked?
    end

    def user_changed?
      session.user_tracked? && session.user_id != current_user_id
    end

    def current_user_id
      current_user.try(:id)
    end

    def default_event_properties
      @default_event_properties ||= fetch_default_properties
    end

    def fetch_default_properties(properties = {})
      if Sojourn.config.default_properties_block
        @ctx.define_singleton_method :sojourn_event_properties,
                                     Sojourn.config.default_properties_block
      end
      @ctx.sojourn_event_properties(properties) if @ctx.respond_to? :sojourn_event_properties
      properties
    end
  end
end
