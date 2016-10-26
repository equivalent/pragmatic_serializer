[![Build Status](https://travis-ci.org/Pobble/pragmatic_serializer.svg?branch=master)](https://travis-ci.org/Pobble/pragmatic_serializer)

# PragmaticSerializer

Pragmatic Serializer for Ruby & Ruby on Rails JSON API.


## About

Although we agre that [JSON API standard proposal](http://jsonapi.org/)
is great, it may be overkill to implement some of it's features (like the way nesting is done) for smaller
API Endpoints.

Therefore if you feel that implementing
[Active Model Serializer](https://github.com/rails-api/active_model_serializers) (JSON API Rails gem)
is not the best choice for your situation/app this gem may be useful for you
too.

We were heavily inspired by [Stormpath API talk on JSON API](https://www.youtube.com/watch?v=hdSrT4yjS1g)
and the pragmatic way they solve some common issues.

Also the gem don't extend anything Rails wise (therefore Sinatra can use
it too), it just provides a generic
way to build Plain Ruby Object Serializers that you can call `as_json`
on to produce hash that you can then pass to `render json:
DocumentSerializer.new(Document.last).as_json`

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'pragmatic_serializer'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install pragmatic_serializer

## Usage


#### Collections

```ruby
r1 = Band.first
r2 = Band.last

class BandPolicy
  attr_reader :current_user

  def initialize(current_user:)
    @current_user = current_user
  end

  def can_view_counters?
    current_user.admin == true
  end
end

class MySerializer
  include PragmaticSerializer::All

  attr_accessor :policy

  def main_json
    hash = { title: band.title }
    hash.merge!(view_count: band.view_count) if policy.can_view_counters?
    hash
  end
end

policy = BandPolicy.new(current_user: current_user)

serializer = MySerializer.collection([r1, r2], resource_options: { :"policy=" => policy })
serializer.as_json
```

As regular user:

```json
{
  "id":"123",
  "type":"band",
  "title":"Bring Me The Horizon"
}
```

As admin

```json
{
  "id":"123",
  "type":"band",
  "title":"Bring Me The Horizon",
  "view_count": 2001
}
```

#### Change ID field

by default the ID field is models `#id`. To change it

```
# config/initializers/pragmatic_serializer.rb

PragmaticSerializer.config.default_id_source = :public_uid  # if you using https://github.com/equivalent/public_uid

# ..or
PragmaticSerializer.config.default_id_source = :url_slug    # custom field
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/pragmatic_serializer. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

