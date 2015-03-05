module Sojourn
  class Campaign < ActiveRecord::Base

    has_many :requests, foreign_key: :sojourn_campaign_id
    has_many :events, through: :requests

    class << self

      def from_request(request)
        return unless (request.tracked_params).any?
        where(params: request.tracked_params.to_param.try(:truncate, 2048)).first_or_initialize
      end

    end
  end
end
