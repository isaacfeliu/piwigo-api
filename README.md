# Piwigo-API

![](https://github.com/kkdad/piwigo-api/workflows/Ruby/badge.svg)  [![codecov](https://codecov.io/gh/KKDad/piwigo-api/branch/master/graph/badge.svg)](https://codecov.io/gh/KKDad/piwigo-api)  ![](https://github.com/kkdad/piwigo-api/workflows/Ruby%20Gem/badge.svg) [![Gem Version](https://badge.fury.io/rb/piwigo-api.svg)](https://badge.fury.io/rb/piwigo-api)  

[Piwigo](https://piwigo.org/) is open source web application to manage your collection of photos, and other medias. Piwigo provides an API for interacting with it. 

This is a ruby-based client for interacting with a Piwigo instance using the Piwigo API.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'piwigo-api'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install piwigo-api

## Usage

Just include 'piwigo/session' and the related classes, then querying Piwigo is fairly quick and straightforward. The latest RubyDocs for [piwigo-api](https://rubydoc.info/github/KKDad/piwigo-api) can be loacated on [rubydoc.info](https://rubydoc.info).

### Get the second album and all of it's children

```ruby
require 'piwigo/session'
require 'piwigo/albums'

session = Piwigo::Session.login('mypiwigo.fqdn', 'Adrian', 'mypassword', https: false) 
unless session.nil? 
    albums = Piwigo::Albums.list(session, album_id: 2, recursive: true)
    albums.each { |album| p "#{album.id}, #{album.name} - # of photos: #{album.total_nb_images}" }
end
```

### Add a new album
```ruby
require 'piwigo/session'
require 'piwigo/albums'

session = Piwigo::Session.login('10.100.230.78', 'Adrian', 'mypassword', https: false) 
unless session.nil? 
    album = Piwigo::Albums::Album.new
    album.name = "My First Album"
    album = Piwigo::Albums.add(session, album)
end
```

### List the Contents of an Album

```ruby
require 'piwigo/session'
require 'piwigo/images'

session = Piwigo::Session.login('mypiwigo.fqdn', 'Adrian', 'mypassword', https: false) 
unless session.nil? 
    results = Piwigo::Images.getImages(session, album_id: 4)
    results[:images].each { |image| p "#{image.id}, #{image.name} - #{image.element_url}" }
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/kkdad/piwigo-ruby.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
