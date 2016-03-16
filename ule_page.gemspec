# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ule_page/version'

Gem::Specification.new do |spec|
  spec.name          = "ule_page"
  spec.version       = UlePage::VERSION
  spec.authors       = ["Jeremy Cui"]
  spec.email         = ["tsuijy@gmail.com"]

  spec.summary       = %q{ Page model for cucumber test.}
  spec.description   = %q{ Based on the siteprism gem, add more page methods and looking for page model via current_path.}
  spec.homepage      = "https://github.com/jerecui/ule_page"
  spec.license       = "MIT"


  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  # if spec.respond_to?(:metadata)
  #   spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  # else
  #   raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  # end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 1.9.3'
  spec.platform    = Gem::Platform::RUBY

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency("activesupport")


  spec.add_dependency "site_prism", "> 2.1"
  spec.add_dependency "capybara", ['>= 2.1', '< 3.0']
  spec.add_dependency "rspec", "~> 3.0"
  spec.add_dependency "activesupport", '> 4.0'
  spec.add_dependency "activerecord", '> 4.0'

  spec.add_development_dependency "rails"
  spec.add_development_dependency "rspec-rails"

  spec.add_development_dependency "rspec-its", "~> 1.0"
  spec.add_development_dependency "cucumber", "~> 1.3.15"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "activerecord", ">= 3.0.0"
  spec.add_development_dependency "yard"

end
