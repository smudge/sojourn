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

To install migrations, execute:

    $ rails g sojourn:install

## How It Works

Sojourn assigns each visitor a unique UUID, which is tracked across requests.

Visitors may have multiple "visits" to your site. Sojourn will create a new "visit" each time
any of the following is true:

* The visitor is new and has no prior visits.
* The visitor has expired after inactivity (default: 1 week) and has been recreated.
* The current visit has expired after inactivity (default: 1 day).
* The request has a 'referer' and it does not match the host.
* The request has UTM data attached (utm_source, utm_campaign, etc).

In this way, you know each time someone visits your site through an external source.

## Current Limitations (i.e. the 'todo' list)

* Tested only on rails 3.2.18 and ruby 2.0.0 with ActiveRecord and PostgreSQL.
* Assumes `User` class exists.
* Assumes `current_user` is defined in controllers.
* Relies on cookies to track visitor UUID across requests.
* Relies too heavily on the datastore (requires at least one DB query per request)
* There are no tests.
