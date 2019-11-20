$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'piwigo'
require 'piwigo/session'
require 'piwigo/albums'
require 'piwigo/images'

require 'minitest/autorun'

require 'simplecov'
SimpleCov.start

require 'codecov'
SimpleCov.formatter = SimpleCov::Formatter::Codecov
