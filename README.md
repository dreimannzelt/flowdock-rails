# Flowdock::Rails

This gem adds a class method to send notifications to specific flows for create and update events on the enabled resource

## Installation

Add this line to your application's Gemfile:

    gem 'flowdock-rails'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install flowdock-rails

## Usage

Just put the `notify_flow` method to your model

    class Model < ActiveRecord::Base
      notify_flow
    end

and dont forget to set the ENV:

    FLOWDOCK_RAILS_API_TOKEN=__FLOW_API_TOKEN__

You can also set the API token directly in your model:

    class Model < ActiveRecord::Base
      notify_flow api_token: "__FLOW_API_TOKEN__"
    end

and of course your are able to notify multiple flows:

    class Model < ActiveRecord::Base
      notify_flow api_token: ["__FLOW_API_TOKEN__1", "__FLOW_API_TOKEN__2"]
    end

or as ENV:

    FLOWDOCK_RAILS_API_TOKEN=__FLOW_API_TOKEN__1,__FLOW_API_TOKEN__2


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
