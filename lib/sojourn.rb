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

  def self.tables_exist?
    @tables_exist ||= %w(sojourn_events sojourn_requests)
                      .map { |t| ActiveRecord::Base.connection.table_exists?(t) }.all?
  end

  def self.track_raw_event!(name, properties)
    Event.create! sojourner_uuid: '!unknown', name: name, properties: properties
  end
end

ActionController::Base.send :include, Sojourn::Controller
