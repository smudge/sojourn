Sojourn.configure do |config|

  # A new "Visit" is created whenever a tracked campaign URL param is detected.
  # Note: It is not recommended you use any of these params in links on your site,
  #       or you will end up with many redundant "Visit" objects being created.
  # Default value: [:utm_source, :utm_medium, :utm_term, :utm_content, :utm_campaign]
  #
  # config.campaign_params += [:my_custom_tracking_param]

end
