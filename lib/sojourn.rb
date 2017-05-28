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

  def self.table_exists?
    @table_exists ||= ActiveRecord::Base.connection.table_exists?('sojourn_events')
  end

  def self.track_raw_event!(name, properties)
    Event.create! sojourner_uuid: '!unknown', name: name, properties: properties
  end
end

ActionController::Base.send :include, Sojourn::Controller
