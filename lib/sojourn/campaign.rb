module Sojourn
  class Campaign < ActiveRecord::Base

    has_many :requests, foreign_key: :sojourn_campaign_id
    has_many :events, through: :requests

    class << self

      def from_request(request)
        return unless (tracked_params = tracked_params(request.params)).any?
        where(path: request.path).where(params: tracked_params.to_param).first_or_initialize
      end

    private

      def tracked_params(params)
        Hash[params.slice(*Sojourn.config.campaign_params).delete_if { |k,v| v.blank? }.sort]
      end

    end
  end
end
