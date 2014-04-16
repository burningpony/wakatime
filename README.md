# Wakatime Ruby 
  [![Code Climate](https://codeclimate.com/github/burningpony/wakatime.png)](https://codeclimate.com/github/burningpony/wakatime)
    An Unoffical Wakatime Ruby API Client

## Installation

Add this line to your application's Gemfile:

    gem 'wakatime'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install wakatime

## Usage

    @session = Wakatime::Session.new({
        api_key: ENV['wakatime_api_key']
    })

    @client = Wakatime::Client.new(@session)

#### Summary
    @client.summary

#### Daily Summary
    @client.daily

#### Daily Summary
    @client.daily

#### Actions
    @client.actions

#### Current User
    @client.current_user
    
#### Plugin Data
    @client.plugins
    

## Testing

  1. Ensure your API Key is in a yaml file in spec/support/account.yml


## Contributing

1. Fork it ( https://github.com/burningpony/wakatime/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Credits

  Massive Credit to [Ruby Box][https://github.com/attachmentsme/ruby-box] as being a template API client. 
