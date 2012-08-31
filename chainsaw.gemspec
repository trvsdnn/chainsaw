# -*- encoding: utf-8 -*-
require File.expand_path('../lib/chainsaw/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["ljfauscett"]
  gem.email         = ["ljfauscett@gmail.com"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "chainsaw"
  gem.require_paths = ["lib"]
  gem.version       = Chainsaw::VERSION

  gem.add_development_dependency 'minitest', '~> 3.0.0'
  gem.add_development_dependency 'mocha', '~> 0.11.4'
end
