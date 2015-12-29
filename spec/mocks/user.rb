module Mocks
  class User
    attr_accessor :id

    def initialize(id = rand(10000))
      self.id = id
    end
  end
end
