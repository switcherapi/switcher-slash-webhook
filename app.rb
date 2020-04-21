require 'sinatra'
require 'sinatra/config_file'
require 'net/http'
require 'json'
require 'bundler'
require_relative 'middleware/validator'

ENV['RACK_ENV'] ||= 'development'

Bundler.require :default, ENV['RACK_ENV'].to_sym

class App < Sinatra::Base
    use Validator

    register Sinatra::ConfigFile
    config_file "config/#{ENV["RACK_ENV"]}.yaml"

    get '/cmd' do
        slashText = params['text']

        if slashText == 'status'
            LoadBalanceController.command(settings)
        elsif slashText != nil && slashText.start_with?('check')
            ApiController.command(settings, slashText)
        else
            Rack::Response.new(
                { text: "Command not found - try: 'status' or 'check'"}
                .to_json, 404, { 'Content-Type' => 'application/json' }).finish
        end
    end

    get '*' do
        Rack::Response.new(
            { message: "use /cmd [status/check]" }.to_json, 200, 
            { 'Content-Type' => 'application/json' }).finish
    end

end