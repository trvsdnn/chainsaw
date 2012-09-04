# -*- encoding: utf-8 -*-
require File.expand_path('../lib/chainsaw/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ['blahed', 'ljfauscett']
  gem.email         = ['tdunn13@gmail.com']
  gem.description   = 'Filter logfiles based on a time range'
  gem.summary       = 'Filter logfiles based on a time range. Uses chronic so your time arguments can be almost anything.'
  gem.homepage      = 'https://github.com/blahed/chainsaw/'

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = 'chainsaw'
  gem.require_paths = ['lib']
  gem.version       = Chainsaw::VERSION

  gem.add_dependency 'chronic', '~> 0.7.0'

  gem.add_development_dependency 'rake', '~> 0.9.2.2'
  gem.add_development_dependency 'minitest', '~> 3.0.0'
  gem.add_development_dependency 'mocha', '~> 0.11.4'
end
