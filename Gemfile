source ENV['GEM_SOURCE'] || 'https://rubygems.org'

def location_for(place, fake_version = nil)
  mdata = /^(git[:@][^#]*)#(.*)/.match(place)
  if mdata
    hsh = { git: mdata[1], branch: mdata[2], require: false }
    return [fake_version, hsh].compact
  end
  mdata2 = %r{^file:\/\/(.*)}.match(place)
  if mdata2
    return ['>= 0', { path: File.expand_path(mdata2[1]), require: false }]
  end
  [place, { require: false }]
end

group :development do
  gem 'guard'
  gem 'guard-rspec'
  gem 'guard-rubocop'
  gem 'guard-shell'
end

group :development, :test do
  gem 'yard'
  gem 'redcarpet'
  gem 'rake', '~> 10.1.0',       require: false
  gem 'rspec', '~> 3.0.0'
  gem 'rspec-mocks', '~> 3.0.0'
  gem 'pry',                     require: false
  gem 'pry-doc',                 require: false
  gem 'pry-stack_explorer',      require: false
  gem 'simplecov',               require: false
  gem 'puppetlabs_spec_helper'
  gem 'puppet-lint'
  gem 'metadata-json-lint'
end

ENV['GEM_PUPPET_VERSION'] ||= ENV['PUPPET_GEM_VERSION']
puppetversion = ENV['GEM_PUPPET_VERSION']
if puppetversion
  gem 'puppet', *location_for(puppetversion)
else
  gem 'puppet', require: false
end

netdev_stdlib_version = ENV['GEM_NETDEV_STDLIB_VERSION']
if netdev_stdlib_version
  gem 'puppetmodule-netdev_stdlib', *location_for(netdev_stdlib_version)
else
  gem 'puppetmodule-netdev_stdlib', '~> 0.10.0'
end

rbeapiversion = ENV['GEM_RBEAPI_VERSION']
if rbeapiversion
  gem 'rbeapi', *location_for(rbeapiversion)
else
  gem 'rbeapi', require: false
end
# vim:ft=ruby
