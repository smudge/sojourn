require 'browser'
require_relative 'campaign'
require_relative 'serializers/symbol'

module Sojourn
  class Request < ActiveRecord::Base

    serialize :method, Serializers::Symbol
    serialize :params

    belongs_to :campaign, foreign_key: :sojourn_campaign_id

    def self.from_request(request)
      new referer: request.referer.try(:truncate, 2048),
          host: request.host.try(:truncate, 2048),
          path: request.path.try(:truncate, 2048),
          controller: request.params[:controller],
          action: request.params[:action],
          params: request.filtered_parameters.with_indifferent_access.except(:controller, :action),
          method: request.method_symbol,
          ip_address: request.remote_ip,
          user_agent: request.user_agent
    end

    before_validation do
      self.campaign = Campaign.from_request(self)
    end

    def bot?
      browser.bot?
    end

    def outside_referer?
      referer.present? && URI.parse(referer).host != host
    end

    def any_utm_data?
      Sojourn.config.campaign_params.map { |p| params[p].present? }.any?
    end

  private

    def browser
      @browser ||= Browser.new(user_agent: user_agent)
    end

  end
end
