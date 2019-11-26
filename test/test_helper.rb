require 'simplecov'

SimpleCov.start do
  add_filter '/test/'
  track_files '/**/*.rb'
end

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'minitest/autorun'
require 'piwigo'
require 'piwigo/session'
require 'piwigo/albums'
require 'piwigo/images'
require 'piwigo/folder_sync'
require 'piwigo/image_uploader'

if !ENV['CODECOV_TOKEN'].nil?
  require 'codecov'
  SimpleCov.formatter = SimpleCov::Formatter::Codecov
else
  require 'minitest/reporters'
  Minitest::Reporters.use! [Minitest::Reporters::SpecReporter.new(color: true)]
end
