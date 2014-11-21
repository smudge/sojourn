require_relative 'campaign'
require_relative 'browser'
require_relative 'serializers/symbol'

module Sojourn
  class Request < ActiveRecord::Base
    attr_accessor :user_agent

    serialize :method, Serializers::Symbol
    serialize :params

    belongs_to :campaign, foreign_key: :sojourn_campaign_id
    belongs_to :browser, foreign_key: :sojourn_browser_id
    has_many :events, foreign_key: :sojourn_request_id

    def self.from_request(request)
      new referer: request.referer.try(:truncate, 2048),
          host: request.host.try(:truncate, 2048),
          path: request.path.try(:truncate, 2048),
          controller: request.params[:controller],
          action: request.params[:action],
          params: request.filtered_parameters.with_indifferent_access.except(:controller, :action),
          method: request.request_method_symbol,
          ip_address: request.remote_ip,
          user_agent: request.user_agent
    end

    before_validation do
      self.campaign ||= Campaign.from_request(self)
      self.browser ||= Browser.from_request(self) if user_agent
    end

    def outside_referer?
      referer.present? && URI.parse(referer).host != host
    end

    def any_utm_data?
      Sojourn.config.campaign_params.map { |p| params[p].present? }.any?
    end
  end
end
