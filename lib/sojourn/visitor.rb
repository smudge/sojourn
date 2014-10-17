require 'browser'
module Sojourn

  def self.table_name_prefix
    'sojourn_'
  end

  class Visitor < ActiveRecord::Base

    has_many :visits, foreign_key: :sojourn_visitor_id
    belongs_to :user

    scope :unexpired, (lambda do
      eager_load(:visits).where('sojourn_visits.last_active_at > ?', 1.week.ago)
    end)

    before_create { self.uuid = SecureRandom.uuid }

    class << self

      def find_from_uuid(uuid, user = nil)
        where(uuid: uuid).unexpired.last
      end

      def create_from_request!(request, user = nil)
        create! ip_address: request.remote_ip, user_agent: request.user_agent, user: user
      end

    end

  end
end
