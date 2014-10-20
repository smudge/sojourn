class Configuration

  attr_accessor :campaign_params

  def initialize
    set_defaults
  end

private

  def set_defaults
    self.campaign_params = [:utm_source, :utm_medium, :utm_term, :utm_content, :utm_campaign]
  end

end
