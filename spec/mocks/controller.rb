require 'mocks/user'
require 'mocks/request'
require 'mocks/cookie'

module Mocks
  class Controller
    attr_accessor :current_user, :request, :cookies

    def initialize(user = User.new, request = Request.new, cookies = Cookie.new)
      self.current_user = user
      self.request = request
      self.cookies = cookies
    end
  end
end
