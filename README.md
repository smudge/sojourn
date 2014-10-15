# Sojourn

Simple user source tracking for Rails. Tracks visitors based on:

* Referer
* UTM parameters
* Fingerprint (IP Address & User Agent)
* Logged-in user (i.e. `current_user`)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'sojourn'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sojourn

## How It Works

Sojourn assigns each visitor a unique UUID, which is tracked across requests.

Sojourn will create a new "visit" event each time any of the following are true:

* No visitor exists in the session, or visitor has expired (default: 1 month)
* If the request has a 'referer' and it does not match the host.
* If the request has any UTM data attached (utm_source, utm_campaign, etc)

In this way, you know each time someone visits your site through an external source.
