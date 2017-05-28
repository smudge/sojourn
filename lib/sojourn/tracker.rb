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
      return unless Sojourn.table_exists?
      properties = default_event_properties.merge(properties)
      Event.create! sojourner_uuid: sojourner_uuid, name: event_name,
                    properties: properties, user_id: user_id
    end

    def sojourning!
      return unless Sojourn.config.tracking_enabled && Sojourn.table_exists?
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
      @request ||= Request.new(ctx.request)
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

    def fetch_default_properties(properties = {}) # rubocop:disable Metrics/AbcSize
      if Sojourn.config.default_properties_block
        @ctx.define_singleton_method :sojourn_event_properties,
                                     Sojourn.config.default_properties_block
      end
      @ctx.sojourn_event_properties(properties) if @ctx.respond_to? :sojourn_event_properties
      properties[:request] = request.raw_data
      properties[:campaign] = request.tracked_params if request.tracked_params.any?
      properties[:browser] = request.browser_data
      properties[:referer] = request.referer_data if request.referer_data.any?
      properties
    end
  end
end
