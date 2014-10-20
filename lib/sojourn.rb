require_relative 'sojourn/version'
require_relative 'sojourn/controller'

ActionController::Base.send :include, Sojourn::Controller
