require_relative 'serializers/indifferent_json'

module Sojourn
  class Event < ActiveRecord::Base
    DEFAULT_FIELDS = %i[id sojourner_uuid name properties user_id created_at].freeze

    belongs_to :user

    serialize :properties, Serializers::IndifferentJSON

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
