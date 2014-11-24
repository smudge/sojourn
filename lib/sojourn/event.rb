module Sojourn
  class Event < ActiveRecord::Base
    DEFAULT_FIELDS = [:id, :sojourner_uuid, :name, :properties, :sojourn_request_id, :user_id, :created_at]

    belongs_to :request, foreign_key: :sojourn_request_id
    belongs_to :user
    has_one :campaign, through: :request
    has_one :browser, through: :request

    serialize :properties

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
