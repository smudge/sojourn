require_relative 'serializers/indifferent_json'

module Sojourn
  class Event < ActiveRecord::Base
    DEFAULT_FIELDS = %i(id sojourner_uuid name properties user_id created_at)

    belongs_to :user

    if ActiveRecord::VERSION::MAJOR >= 7 && ActiveRecord::VERSION::MINOR >= 1 || ActiveRecord::VERSION::MAJOR >= 8
      serialize :properties, coder: Serializers::IndifferentJSON
    else
      serialize :properties, Serializers::IndifferentJSON
    end

    before_save do
      properties.keys.map(&:to_sym).each do |key|
        send("#{key}=", properties[key]) if self.class.available_fields.include?(key)
      end
    end

    def self.available_fields
      @available_fields ||= column_names.map(&:to_sym) - DEFAULT_FIELDS
    end
  end
end
