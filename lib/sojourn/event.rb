module Sojourn
  class Event < ActiveRecord::Base
    belongs_to :request, foreign_key: :sojourn_request_id
    belongs_to :user
    serialize :properties
  end
end
