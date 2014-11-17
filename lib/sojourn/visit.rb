require_relative 'campaign'
require_relative 'serializers/symbol'
module Sojourn
  def self.table_name_prefix
    'sojourn_'
  end

  class Visit < ActiveRecord::Base

    serialize :method, Serializers::Symbol

    belongs_to :visitor, foreign_key: :sojourn_visitor_id
    belongs_to :campaign, foreign_key: :sojourn_campaign_id
    belongs_to :user
    has_many :events, foreign_key: :sojourn_visit_id

    before_create { self.uuid = SecureRandom.uuid }

    class << self

      def create_from_request!(request, visitor, user = nil, time = Time.now)
        create! referrer: request.referer.try(:truncate, 2048),
                host: request.host.try(:truncate, 2048),
                path: request.fullpath.try(:truncate, 2048),
                method: request.method_symbol,
                campaign: Campaign.from_request(request),
                visitor: visitor,
                user: user,
                created_at: time
      end

    end

  end
end
