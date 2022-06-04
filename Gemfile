source "https://rubygems.org"

gem "sinatra"
gem 'sinatra-contrib'
gem 'puma'

group :test, :development do
  gem "rake"
  gem 'rspec'
end
  
group :test do
  gem 'coveralls_reborn', '~> 0.24.0', require: false
  gem 'rack-test'
  gem 'webmock', '>= 3.8.3'
end