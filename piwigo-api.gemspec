lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'piwigo/version'

Gem::Specification.new do |spec|
  spec.name          = 'piwigo-api'
  spec.version       = Piwigo::VERSION
  spec.authors       = ['Adrian Gilbert']
  spec.email         = ['adrian@gilbert.ca']

  spec.summary       = 'Gem to interact with the Piwigo API'
  spec.description   = 'Piwigo is open source web application to manage your collection of photos, and other medias. Piwigo provides an API for interacting with it. This is a ruby-based client for interacting with a Piwigo instance using the Piwigo API.'
  spec.homepage      = 'https://github.com/kkdad/piwigo-api'
  spec.license       = 'MIT'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/kkdad/piwigo-api'
  spec.metadata['changelog_uri'] = 'https://github.com/kkdad/piwigo-api/CHANGELOG.md'
  spec.metadata['documentation_uri'] = 'https://rubydoc.info/github/KKDad/piwigo-api/master'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'codecov', '>= 0.1.10'
  spec.add_development_dependency 'minitest', '~> 5.0'
  spec.add_development_dependency 'minitest-reporters', '~>1.4'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'simplecov', '~> 0.17'

  spec.add_runtime_dependency 'http', '~>4.2'
  spec.add_runtime_dependency 'logger', '~>1.4'
  spec.add_runtime_dependency 'exifr', '~>1.3'
end
