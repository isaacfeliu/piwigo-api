require 'simplecov'

SimpleCov.start do
  track_files '**/*.rb'
end
require 'minitest/autorun'
require 'codecov'

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'piwigo'
require 'piwigo/session'
require 'piwigo/albums'
require 'piwigo/images'

SimpleCov.formatter = SimpleCov::Formatter::Codecov
