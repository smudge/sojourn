module Sojourn
  def self.table_name_prefix
    'sojourn_'
  end

  class Visit < ActiveRecord::Base

    belongs_to :request, foreign_key: :sojourn_request_id
    belongs_to :visitor, foreign_key: :sojourn_visitor_id
    belongs_to :user
    has_many :events, foreign_key: :sojourn_visit_id
    has_one :campaign, through: :request

    before_create { self.uuid = SecureRandom.uuid }

  end
end
