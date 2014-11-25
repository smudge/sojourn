module Sojourn
  class Campaign < ActiveRecord::Base

    has_many :requests, foreign_key: :sojourn_campaign_id
    has_many :events, through: :requests

    class << self

      def from_request(request)
        return unless (params = tracked_params(request.params)).any?
        where(path: request.path.downcase.try(:truncate, 2048))
          .where(params: params.to_param.try(:truncate, 2048)).first_or_initialize
      end

    private

      def tracked_params(params)
        Hash[filter_params(params).sort.map { |k, v| [k.downcase, v.downcase] }]
      end

      def filter_params(params)
        params.slice(*Sojourn.config.campaign_params).delete_if { |_, v| v.blank? }
      end

    end
  end
end
