module Sojourn
  class Event < ActiveRecord::Base
    belongs_to :visit, foreign_key: :sojourn_visit_id
    belongs_to :request, foreign_key: :sojourn_request_id
    serialize :properties
  end
end
