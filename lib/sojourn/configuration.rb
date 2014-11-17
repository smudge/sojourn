class Configuration

  attr_accessor :campaign_params
  attr_accessor :visitor_expires_after
  attr_accessor :visit_expires_after

  def initialize
    set_defaults
  end

private

  def set_defaults
    self.campaign_params = [:utm_source, :utm_medium, :utm_term, :utm_content, :utm_campaign]
    self.visitor_expires_after = 1.week
    self.visit_expires_after = 1.day
  end

end
