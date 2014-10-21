module Sojourn
  class Event < ActiveRecord::Base
    belongs_to :visit, foreign_key: :sojourn_visit_id
    serialize :properties
  end
end
