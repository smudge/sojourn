require 'securerandom'

module Mocks
  class User
    attr_accessor :id

    def initialize(id = SecureRandom.uuid)
      self.id = id
    end
  end
end
