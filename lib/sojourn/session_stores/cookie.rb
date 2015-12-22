module Sojourn
  module SessionStores
    class Cookie
      def initialize(ctx)
        @ctx = ctx
      end

      def sojourner_uuid
        cookie_data[:uuid]
      end

      def sojourner_uuid=(value)
        cookies.permanent.signed[cookie_name] = { value: cookie_data.merge(uuid: value) }
      end

      def sojourner_tracked?
        cookie_data.key?(:uuid)
      end

      def user_id
        cookie_data[:user_id]
      end

      def user_id=(value)
        cookies.permanent.signed[cookie_name] = { value: cookie_data.merge(user_id: value) }
      end

      def user_tracked?
        cookie_data.key?(:user_id)
      end

    private

      def cookie_data
        cookies.signed[cookie_name] || {}
      end

      def cookies
        @ctx.send(:cookies)
      end

      def cookie_name
        @cookie_name ||= Sojourn.config.cookie_name
      end
    end
  end
end
