# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'rack/content_type_validator'

Gem::Specification.new do |s|
  s.name        = "rack-content_type_validator"
  s.version     = Rack::ContentTypeValidator::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Lucas Fais"]
  s.email       = ["lucasfais@gmail.com"]
  s.homepage    = "http://github.com/abril/rack-content_type_validator"
  s.summary     = %q{Makes easy to handle mutipart/related requests.}
  s.description = %q{It's a rack middleware to parse multipart/related requests and rebuild a simple/merged parameters hash.}

  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project         = "rack-content_type_validator"

  s.add_dependency "rack", '>= 1.0'
  
  s.add_development_dependency "step-up"

  excepts = %w[
    .gitignore
    rack-multipart_related.gemspec
  ]
  tests = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.files              = `git ls-files`.split("\n") - excepts - tests
  s.test_files         = tests
  s.require_paths      = ["lib"]
end