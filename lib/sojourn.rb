require 'sojourn/version'
require 'sojourn/visitor'
require 'sojourn/visit'
require 'sojourn/controller'

ActionController::Base.send :include, Sojourn::Controller
