require 'securerandom'
require 'addressable/uri'
require 'browser'
require 'referer-parser'

module Sojourn
  class Request
    KEYS = %w(uuid referer host path controller action params method ip_address user_agent)

    attr_reader :request

    def initialize(request)
      @request = request
    end

    def outside_referer?
      referer.present? && referer_host != host
    end

    def any_utm_data?
      tracked_param_keys.map { |p| downcased_params[p].present? }.any?
    end

    def tracked_params
      Hash[downcased_params.slice(*tracked_param_keys).delete_if { |_, v| v.blank? }.sort]
    end

    def raw_data
      Hash[KEYS.map { |k| [k, send(k)] }].with_indifferent_access
    end

    def browser_data
      return @browser_data if @browser_data
      @browser_data = {
        name: browser.name,
        version: browser.version,
        platform: browser.platform,
        bot: browser.bot?,
        known: browser.known?
      }
    end

    def referer_data
      return @referer_data if @referer_data
      p = RefererParser::Parser.new.parse(sanitized_referer)
      @referer_data = {
        known: p[:known],
        host: referer_host,
        source: p[:source],
        medium: p[:medium],
        term: p[:term]
      }
    rescue
      @referer_data = {}
    end

  private

    def uuid
      @uuid ||= request.uuid || SecureRandom.uuid
    end

    def referer
      @referer ||= request.referer.try(:truncate, 2048)
    end

    def host
      @host ||= request.host.try(:truncate, 2048)
    end

    def path
      @path ||= request.path.try(:truncate, 2048)
    end

    def controller
      @controller ||= request.params[:controller]
    end

    def action
      @action ||= request.params[:action]
    end

    def params
      @params ||= request.filtered_parameters.with_indifferent_access.except(:controller, :action)
    end

    def method
      @method ||= request.request_method_symbol
    end

    def ip_address
      @ip_address ||= request.remote_ip
    end

    def user_agent
      @user_agent ||= request.user_agent
    end

    def referer_host
      @referer_host ||= parsed_referer.host
    end

    def sanitized_referer
      @sanitized_referer ||= parsed_referer.display_uri
    end

    def parsed_referer
      @parsed_referer ||= Addressable::URI.parse(referer)
    end

    def downcased_params
      params.each_with_object({}) { |(k, v), h| h[k.to_s.downcase] = v }
    end

    def tracked_param_keys
      Sojourn.config.campaign_params.map(&:to_s).map(&:downcase)
    end

    def browser
      @browser ||= Browser.new(user_agent: user_agent) if user_agent
    end
  end
end
