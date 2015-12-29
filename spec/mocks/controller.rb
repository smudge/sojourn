require 'mocks/user'
require 'mocks/request'
require 'mocks/cookie'

module Mocks
  class Controller
    attr_accessor :current_user, :request

    def initialize(user, request)
      self.current_user = user
      self.request = request
    end

    def cookies
      Cookie.new
    end
  end
end
