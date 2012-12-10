# -*- encoding: utf-8 -*-
require File.expand_path('../lib/inventory/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Rick Button"]
  gem.email         = ["me@rickybutton.com"]
  gem.description   = %q{Checks inventory for stores that support online stock checking}
  gem.summary       = %q{Checks inventory for stores that support online stock checking}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "inventory"
  gem.require_paths = ["lib"]
  gem.version       = Inventory::VERSION
  
  %w(rspec guard spork guard-spork guard-rspec rb-fsevent growl vcr webmock rake).each do |g|
    gem.add_development_dependency g
  end
  %w(virtus).each do |g|
    gem.add_runtime_dependency g
  end
end
