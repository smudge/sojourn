require 'simplecov'
SimpleCov.start

require 'bundler/setup'
Bundler.setup

require 'rspec/its'
require 'rails'
require 'active_record'
require 'sojourn'

RSpec.configure do |config|
  config.before(:suite) do
    ActiveRecord::Base.establish_connection adapter: 'sqlite3',
                                            database: ':memory:'

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
    end
  end

  config.before do
    Sojourn::Event.delete_all
  end
end
