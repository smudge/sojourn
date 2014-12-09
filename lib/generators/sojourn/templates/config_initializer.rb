Sojourn.configure do |config|

  # A new '!sojourning' event is created whenever:
  #    1. The 'referer' is external
  #    2. There are utm-style parameters in the request.
  #    3. The visitor is new and has never been assigned a 'sojourner_id' (i.e. direct traffic)
  # The two events '!logged_in' and '!logged_out' are created whenever sojourn detects a
  # change to `current_user`.

  # To disable all automatic event tracking, uncomment the following line:
  # config.tracking_enabled = false

  # You may customize the list of tracked (utm-style) parameters here.
  # Note: Using tracked params on internal links within your site is NOT recommended, as this will
  #       result in many repeated '!sojourning' events. Instead, you should use a different set
  #       of parameters (such as 'from', 'source', or 'referer') and NOT include them here.
  # Default: [:utm_source, :utm_medium, :utm_term, :utm_content, :utm_campaign]
  #
  # config.campaign_params += [:my_custom_tracking_param]

  # By default, sojourn will attach `user_id`, `sojourner_uuid`, and a `created_at` timestamp
  # to every event. If you would like to add additional properties, you may do so as follows.
  # Note: This block will be called in the context of your controller.
  #
  # config.default_properties do |p|
  #   p[:rails_env] = Rails.env
  #   p[:my_custom_property] = method_defined_in_controller
  # end

  # By default, sojourn uses a signed, permanent cookie to store the sojourner uuid. You
  # may specifiy an alternate/custom session_store, or change the name of the cookie that
  # gets created. (default is `:_sojourn`)
  #
  # config.session_store = Sojourn::SessionStores::Cookie
  # config.cookie_name = :my_custom_cookie_name

end
