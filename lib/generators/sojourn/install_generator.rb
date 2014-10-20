require 'rails/generators/active_record'
module Sojourn
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include Rails::Generators::Migration

      desc 'Copies sojourn migrations to your file.'
      source_root File.expand_path('../templates', __FILE__)

      def self.next_migration_number(dirname)
        next_migration_number = current_migration_number(dirname) + 1
        if ::ActiveRecord::Base.timestamped_migrations
          [Time.now.utc.strftime('%Y%m%d%H%M%S'), format('%.14d', next_migration_number)].max
        else
          format('%.3d', next_migration_number)
        end
      end

      def create_config_file
        template "config_initializer.rb", "config/initializers/sojourn.rb"
      end

      def create_migrations
        %w(create_sojourn_visitors create_sojourn_visits).each do |name|
          migration_template "#{name}.rb", "db/migrate/#{name}.rb"
          sleep 1
        end
      end
    end
  end
end
