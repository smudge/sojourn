Sojourn.configure do |config|

  # A new '!sojourning' event is created whenever:
  #    1. The 'referer' is external
  #    2. There are utm-style parameters in the request.
  #    3. The visitor is new and has never been assigned a 'sojourner_id' (i.e. direct traffic)
  # You may customize the list of tracked parameters here.
  # Note: It is not recommended you use any tracked params on internal links within your site,
  #       or you will end up with many repeated '!sojourning' events.
  # Default: [:utm_source, :utm_medium, :utm_term, :utm_content, :utm_campaign]
  #
  # config.campaign_params += [:my_custom_tracking_param]

end
