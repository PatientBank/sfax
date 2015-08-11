# SFax Ruby Gem [![Build Status](https://travis-ci.org/PatientBank/sfax.svg?branch=master)](https://travis-ci.org/PatientBank/sfax)

## What does this gem do?

This gem is a ruby wrapper around the SFax API. With this gem, you can easily send and receive electronic faxes.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'sfax'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install sfax

## Usage

First and foremost, you need to sign up for an SFax account [here](https://www.scrypt.com/sfax/sign-up/integration/) and generate your credentials [here](http://sfax.scrypt.com/article/383-generating-your-api-credentials). 

After that, you can initialize the `Faxer` class as:

```ruby
# All four fields are necessary.
# Username and api_key are used for fax processing.
# Vector and encryptiong_key are used for securing posted url.
SFax::Faxer.new(username, api_key, vector, encryption_key)
```

After this there are four main methods: `send_fax`, `fax_status`, `receive_fax` and `download_fax`.

`send_fax` accepts a `file` and a `fax_number` in the following format: `+1xxxxxxxxxx`. File can be a `Tempfile` or a url. If fax is successfully initiated, `send_fax` returns `fax_id` (a 32-digit alphanumeric id) which can be used to track the fax status. 

`fax_status` accepts a `fax_id` which is returned from `send_fax` and returns the status of the fax with `fax_id`.

`receive_fax` accepts `count`, which is the number of faxes to be received. SFax returns 500 (maximum) faxes at a time, so count is capped at 500. `receive_fax` returns two values: If there are any received faxes, it returns an array of fax ids to be downloaded. If there are more faxes to be received, `receive_fax` also returns `true`. Otherwise it returns `false` along with the array of ids.

`download_fax` accepts a `fax_id` and returns the contents of the fax to be written to a file.

## Best Practices

At PatientBank, we use this gem to make calls to the SFax API via jobs. While sending faxes are triggered via the user, we use `cron` jobs to regularly check if there are any received faxes.

For development environment, it is important to not send or receive faxes from your main fax number. One workaround is to create a new fax number (and its respective API credentials) for use in development machines.

## Resources

[The Basics](http://sfax.scrypt.com/article/617-the-basics-how-it-works)

[Generating API Credentials](http://sfax.scrypt.com/article/383-generating-your-api-credentials)

[SFax Sign up](https://www.scrypt.com/sfax/sign-up/integration/)

## Credits

This gem is inspired by the [sample code](http://sfax.scrypt.com/article/328-code-samples-ruby) SFax provides to its developers. 

## Contributing

1. Fork it (https://github.com/[my-github-username]/sfax/fork)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
