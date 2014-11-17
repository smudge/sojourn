Sojourn.configure do |config|

  # A new "Visit" is created whenever a tracked campaign URL param is detected.
  # Note: It is not recommended you use any of these params in links on your site,
  #       or you will end up with many redundant "Visit" objects being created.
  # Default value: [:utm_source, :utm_medium, :utm_term, :utm_content, :utm_campaign]
  #
  # config.campaign_params += [:my_custom_tracking_param]

  # New "Visitors" and "Visits" will be created after a certain period of inactivity.
  # The default is 1 week and 1 day, respectively, but you may override that here.
  # Setting the value to `nil` will make them never expire as long as they continue
  # to exist in the session.
  #
  # config.visitor_expires_after = 1.week
  # config.visit_expires_after = 1.day

end
