module Sojourn
  def self.table_name_prefix
    'sojourn_'
  end

  class Visit < ActiveRecord::Base

    belongs_to :visitor, foreign_key: :sojourn_visitor_id
    has_one :user, through: :visitor

    before_create { self.uuid = SecureRandom.uuid }

  end
end
