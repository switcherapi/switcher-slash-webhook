source "https://rubygems.org"
gem "sinatra"
gem 'sinatra-contrib'

group :test, :development do
  gem "rake"
  gem 'rspec'
end
  
group :test do
  gem 'simplecov', require: false
  gem 'rack-test'
  gem 'webmock'
  gem 'coveralls', :require => false
  gem 'codeclimate-test-reporter', '~> 1.0.0'
end