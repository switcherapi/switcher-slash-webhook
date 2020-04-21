source "https://rubygems.org"
ruby '2.6.6'

gem "sinatra"
gem 'sinatra-contrib'

group :test, :development do
  gem "rake"
  gem 'rspec'
end
  
group :test do
  gem 'coveralls', '~> 0.8.23'
  gem 'simplecov', require: false
  gem 'rack-test'
  gem 'webmock'
end