# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mongoid-embedded-errors-messages/version'

Gem::Specification.new do |spec|
  spec.name          = "mongoid-embedded-errors-messages"
  spec.version       = MongoidEmbeddedErrorsMessages::VERSION
  spec.authors       = ["Bruno Milare"]
  spec.email         = ["milare@gmail.com"]
  spec.description   = %q{Easiest way to bubble up your embedded documents errors messages.}
  spec.summary       = %q{Easiest way to bubble up your embedded documents errors messages.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "mongoid", ">=3.0.0"
end
