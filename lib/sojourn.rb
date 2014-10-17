require 'sojourn/version'
require 'sojourn/visitor'
require 'sojourn/visit'
require 'sojourn/controller'

module Sojourn
  def self.bot?(request)
    Browser.new(user_agent: request.user_agent).bot?
  end
end

ActionController::Base.send :include, Sojourn::Controller
