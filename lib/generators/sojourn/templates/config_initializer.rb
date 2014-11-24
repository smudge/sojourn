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

  # By default, sojourn uses a signed, permanent cookie to store the sojourner uuid. You
  # may specifiy an alternate/custom session_store, or change the name of the cookie that
  # gets created. (default is `:_sojourn`)
  # config.session_store = Sojourn::SessionStores::Cookie
  # config.cookie_name = :my_custom_cookie_name

end
