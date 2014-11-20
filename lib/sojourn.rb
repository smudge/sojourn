require_relative 'sojourn/version'
require_relative 'sojourn/configuration'
require_relative 'sojourn/controller'

module Sojourn
  def self.table_name_prefix
    'sojourn_'
  end

  def self.configure(&block)
    block.call(config)
  end

  def self.config
    @config ||= Configuration.new
  end
end

ActionController::Base.send :include, Sojourn::Controller
