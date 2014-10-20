module Sojourn
  class Campaign < ActiveRecord::Base

    has_many :visits, foreign_key: :sojourn_campaign_id
    has_many :visitors, through: :visits

    class << self

      def from_request(request)
        where(path: request.path).where(params: param_string(request.params)).first_or_initialize
      end

    private

      def param_string(params)
        params.slice(*Sojourn.config.campaign_params).to_param
      end

    end
  end
end
