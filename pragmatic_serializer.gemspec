# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pragmatic_serializer/version'

Gem::Specification.new do |spec|
  spec.name          = "pragmatic_serializer"
  spec.version       = PragmaticSerializer::VERSION
  spec.authors       = ["Tomas Valent"]
  spec.email         = ["equivalent@eq8.eu"]

  spec.summary       = %q{JSON API serializer following Pragmatic JSON standard}
  spec.description   = %q{JSON API Serializer to produce RESTful serializer using plain Ruby Ojects that follows common sense and heavily inspired by StormpathAPI talks}
  spec.homepage      = "https://github.com/equivalent/pragmatic_serializer"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
