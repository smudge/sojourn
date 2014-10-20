require 'sojourn/version'
require 'sojourn/visitor'
require 'sojourn/visit'
require 'sojourn/controller'

module Sojourn
  class << self
    def bot?(request)
      Browser.new(user_agent: request.user_agent).bot?
    end

    def new_visit_required?(request)
      outside_referer?(request) || any_utm_data?(request)
    end

  private

    def outside_referer?(request)
      request.referer.present? && URI.parse(request.referer).host != request.host
    end

    def any_utm_data?(request)
      request.params[:utm_source].present?  ||
      request.params[:utm_medium].present?  ||
      request.params[:utm_term].present?    ||
      request.params[:utm_content].present? ||
      request.params[:utm_campaign].present?
    end
  end
end

ActionController::Base.send :include, Sojourn::Controller
