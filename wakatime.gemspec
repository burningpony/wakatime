# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'wakatime/version'

Gem::Specification.new do |spec|
  spec.name          = "wakatime"
  spec.version       = Wakatime::VERSION
  spec.authors       = ["Russell Osborne"]
  spec.email         = ["russell@burningpony.com"]
  spec.summary       = %q{A simple ruby gem for accessing Wakatime records}
  spec.description   = %q{A simple ruby gem for accessing Wakatime records}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency(%q<multipart-post>, [">= 0"])
  spec.add_runtime_dependency(%q<json>, [">= 0"])
  spec.add_runtime_dependency(%q<addressable>, [">= 0"])
  spec.add_development_dependency(%q<rspec>, [">= 0"])
  spec.add_development_dependency(%q<bundler>, [">= 0"])
  spec.add_development_dependency(%q<jeweler>, ["~> 1.6.4"])
  spec.add_development_dependency(%q<webmock>, [">= 0"])
end
