# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bolter/version'

Gem::Specification.new do |spec|
  spec.name          = 'bolter'
  spec.version       = Bolter::VERSION
  spec.authors       = ['Evgeniy Shurmin']
  spec.email         = ['eshurmin@gmail.com']
  spec.summary       = %q{This gem include sorting and filtering methods}
  spec.homepage      = 'http://github.com/jpascal/bolter'
  spec.license       = 'MIT'
  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(spec)/}) }
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.8'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'activerecord'
  spec.add_development_dependency 'sqlite3'
  spec.add_development_dependency 'mongoid'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'activesupport'
end
