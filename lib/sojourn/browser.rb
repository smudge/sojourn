require 'browser'

module Sojourn
  class Browser < ActiveRecord::Base
    has_many :requests, foreign_key: :sojourn_browser_id
    has_many :events, through: :requests

    def self.from_request(request)
      where(user_agent: request.user_agent).first_or_initialize
    end

    before_validation do
      self.name ||= browser.name
      self.version ||= browser.version
      self.platform ||= browser.platform
      self.bot ||= browser.bot?
      true # otherwise .valid? will return false
    end

  private

    def browser
      @browser ||= ::Browser.new(user_agent: user_agent)
    end
  end
end
