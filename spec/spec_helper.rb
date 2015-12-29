require 'bundler/setup'
Bundler.setup

require 'rails'
require 'active_record'
require 'sojourn'

RSpec.configure do |config|
  config.before(:suite) do
    ActiveRecord::Base.establish_connection adapter: 'sqlite3', database: ':memory:'

    ActiveRecord::Schema.define do
      self.verbose = false

      create_table :sojourn_events do |t|
        t.string :sojourner_uuid, limit: 36, null: false
        t.string :name
        t.text :properties
        t.references :sojourn_request
        t.references :user
        t.timestamp :created_at
      end

      create_table :sojourn_requests do |t|
        t.string :host, limit: 2048
        t.string :path, limit: 2048
        t.string :method
        t.string :controller
        t.string :action
        t.string :ip_address
        t.text :user_agent
        t.text :params
        t.text :referer
        t.timestamp :created_at
      end
    end
  end
end
