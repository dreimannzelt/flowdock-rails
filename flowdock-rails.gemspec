# encoding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'flowdock/rails/version'

Gem::Specification.new do |spec|
  spec.name          = "flowdock-rails"
  spec.version       = Flowdock::Rails::VERSION
  spec.authors       = ["Björn Wolf"]
  spec.email         = ["bjoern@dreimannzelt.de"]
  spec.description   = "Gem for notifying flows about the creation and updating of ActiveRecord models."
  spec.summary       = "Notify flows of model creations and updates"
  spec.homepage      = "http://github.com/dreimannzelt/flowdock-rails"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"

  spec.add_dependency "flowdock", "~> 0.5"
  spec.add_dependency "activerecord", "> 3.0"
  spec.add_dependency "activesupport", "> 3.0"
end
