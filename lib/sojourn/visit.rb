require_relative 'campaign'
module Sojourn
  def self.table_name_prefix
    'sojourn_'
  end

  class Visit < ActiveRecord::Base

    belongs_to :visitor, foreign_key: :sojourn_visitor_id
    belongs_to :campaign, foreign_key: :sojourn_campaign_id
    has_one :user, through: :visitor
    has_many :events, foreign_key: :sojourn_visit_id

    before_create { self.uuid = SecureRandom.uuid }

    class << self

      def create_from_request!(request, visitor)
        create! referrer: request.referer,
                host: request.host,
                path: request.fullpath,
                campaign: Campaign.from_request(request),
                visitor: visitor
      end

    end

  end
end
