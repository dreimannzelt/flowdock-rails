# Flowdock::Rails

[![Gem Version](https://badge.fury.io/rb/flowdock-rails.svg)](http://badge.fury.io/rb/flowdock-rails)

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

```ruby
class Model < ActiveRecord::Base
  notify_flow
end
```

and dont forget to set the ENV:

```
FLOWDOCK_RAILS_API_TOKEN=__FLOW_API_TOKEN__
```

You can also set the API token directly in your model:

```ruby
class Model < ActiveRecord::Base
  notify_flow api_token: "__FLOW_API_TOKEN__"
end
```

and of course your are able to notify multiple flows:

```ruby
class Model < ActiveRecord::Base
  notify_flow api_token: ["__FLOW_API_TOKEN__1", "__FLOW_API_TOKEN__2"]
end
```

or as ENV:

```
FLOWDOCK_RAILS_API_TOKEN=__FLOW_API_TOKEN__1,__FLOW_API_TOKEN__2
```

### Enabling and Disabling

It is enabled for production environments per default. You can enable it by setting ENV for other environments:

```
FLOWDOCK_RAILS_ENABLED=true
```

You can also explicitly disable it on production with:

```
FLOWDOCK_RAILS_ENABLED=false
```

If a global enabling/disabling mechanism is not sufficient enough for you, just override it on a per-class basis:

```ruby
class Model < ActiveRecord::Base
  def self.push_to_flow_enabled?
    false
  end
end
```

#### WARNING !!!

It's force-disabled on RAILS_ENV=test by default. Currently there is no way to enable it besides overriding the class method `self.push_to_flow_enabled?`

### All ENV variables

| Variable | Description | Default |
|---|---|---|
| FLOWDOCK_RAILS_API_TOKEN  | YOUR_API_TOKEN |
| FLOWDOCK_RAILS_ENABLED    | Explicitly enable pushing for anything else than production.| "true" |
| FLOWDOCK_RAILS_NAME       | Set the name of your project| Rails.application.class.parent_name |
| FLOWDOCK_RAILS_FROM_NAME  | Name for the sender| Marv |
| FLOWDOCK_RAILS_FROM_EMAIL | Email for the sender| marv@dreimannzelt.de |
| FLOWDOCK_RAILS_FORMAT     | Format of output of attributes and changes. Possible values: "table",  "json" | "table" |


## TODO

1. Spec, specs, specs, specs!
2. Asynchronous and background job options
3. Option for enabling/disabling specific events (create/update)
4. Option for notification of deletion
5. Better documentation on how to override the content for the notifications

## Thanks to

* @flowdock for this amazing product
* @benedikt for the patches

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
