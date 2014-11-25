require_relative 'session_stores/cookie'

class Configuration

  attr_accessor :campaign_params
  attr_accessor :session_store
  attr_accessor :cookie_name
  attr_accessor :tracking_enabled

  def initialize
    set_defaults
  end

private

  def set_defaults
    self.campaign_params = [:utm_source, :utm_medium, :utm_term, :utm_content, :utm_campaign]
    self.session_store = Sojourn::SessionStores::Cookie
    self.cookie_name = :_sojourn
    self.tracking_enabled = true
  end

end
