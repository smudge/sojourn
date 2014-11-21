module Sojourn
  module SessionStores
    class Cookie

      def initialize(ctx)
        @ctx = ctx
      end

      def sojourner_uuid
        cookies.signed[:sojourner_uuid]
      end

      def sojourner_uuid=(value)
        cookies.permanent.signed[:sojourner_uuid] = value
      end

      def sojourner_tracked?
        cookies.key?(:sojourner_uuid)
      end

      def user_id
        cookies.signed[:sojourn_user_id]
      end

      def user_id=(value)
        cookies.permanent.signed[:sojourn_user_id] = value
      end

      def user_tracked?
        cookies.key?(:sojourn_user_id)
      end

    private

      def cookies
        @ctx.send(:cookies)
      end

    end
  end
end
