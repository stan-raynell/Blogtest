# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.1.2"

gem "rails", "~> 7.0.4", ">= 7.0.4.2"
gem "sass-rails"

gem "sprockets-rails"
gem 'autoprefixer-rails'

gem "devise"

gem "faker"

gem "reek"

gem "rexml"

gem "rubycritic", require: false

gem "sqlite3", "~> 1.4"

gem "passenger"

gem "puma", "~> 5.0"

gem "importmap-rails"

gem "turbo-rails"

gem "stimulus-rails"

gem "jbuilder"

gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]

gem "bootsnap", require: false

group :development, :test do
  gem "debug", platforms: %i[mri mingw x64_mingw]
  gem "factory_bot_rails"
  gem "rspec-rails"
end

group :development do
  gem "web-console"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
  gem "simplecov", require: false
  gem "webdrivers"
end

gem "cssbundling-rails", "~> 1.1"

gem "jsbundling-rails", "~> 1.1"

# Use Redis for Action Cable
gem "autoprefixer-rails"
gem "bootstrap-sass"
gem "redis", "~> 4.0"
