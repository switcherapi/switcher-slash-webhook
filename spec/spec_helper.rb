ENV['RACK_ENV'] = 'test'

require 'simplecov'
SimpleCov.start 'rails' do
  if ENV['CI']
    require 'simplecov-lcov'

    SimpleCov::Formatter::LcovFormatter.config do |c|
      c.report_with_single_file = true
      c.single_report_path = 'coverage/lcov.info'
    end

    formatter SimpleCov::Formatter::LcovFormatter
  end

  add_filter %w[version.rb initializer.rb]
end

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