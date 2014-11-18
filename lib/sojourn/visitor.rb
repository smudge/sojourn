module Sojourn

  def self.table_name_prefix
    'sojourn_'
  end

  class Visitor < ActiveRecord::Base

    has_many :visits, foreign_key: :sojourn_visitor_id
    has_many :events, through: :visits
    has_many :users, through: :visits

    before_create { self.uuid = SecureRandom.uuid }

  end
end
