require_relative 'session_stores/cookie'

class Configuration

  attr_accessor :campaign_params
  attr_accessor :session_store

  def initialize
    set_defaults
  end

private

  def set_defaults
    self.campaign_params = [:utm_source, :utm_medium, :utm_term, :utm_content, :utm_campaign]
    self.session_store = Sojourn::SessionStores::Cookie
  end

end
