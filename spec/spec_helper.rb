ENV['RACK_ENV'] = 'test'

require 'coveralls'
Coveralls.wear!

# require 'simplecov'
# SimpleCov.start 'rails'

require 'webmock/rspec'
require_relative File.join('..', 'app')
require_relative File.join('../controllers', 'loadbalance_controller')
require_relative File.join('../controllers', 'api_controller')

WebMock.disable_net_connect!(allow_localhost: true)

RSpec.configure do |config|
  include Rack::Test::Methods

  def app
    App
  end

  def loadbalance_controller
    LoadBalanceController
  end

  def api_controller
    ApiController
  end
end