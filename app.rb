require 'sinatra'
require 'sinatra/config_file'
require 'net/http'
require 'json'
require './middleware/validator'

class App < Sinatra::Base
    use Validator

    register Sinatra::ConfigFile
    config_file "config/#{ENV["RACK_ENV"]}.yaml"

    get '/cmd' do
        slashCmd = params['command']
        slashText = params['text']

        if slashText == 'status'
            LoadBalanceController.command(settings)
        elsif slashText.start_with?('check')
            ApiController.command(settings, slashText)
        else
            Rack::Response.new(
                { text: "Command not found - try: 'status' or 'check'"}
                .to_json, 404, { 'Content-Type' => 'application/json' }).finish
        end
    end

end