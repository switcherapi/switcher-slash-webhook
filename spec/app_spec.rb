require_relative '../spec/spec_helper'

describe 'Root Path' do
  describe 'GET /' do
    it 'is successful' do
      get '/', :token => "$up3r$s3kr3t"
      expect(last_response).to be_ok
      expect(last_response.body).to eq('{"message":"use /cmd [status/check]"}')
    end

    it 'is not successful - no token provided' do
      get '/'
      expect(last_response.status).to eq 401 
    end
  end

  describe 'GET /cmd' do
    it 'cannot recognize command' do
      get '/cmd', :token => "$up3r$s3kr3t"
      expect(last_response.body).to eq('{"text":"Command not found - try: \'status\' or \'check\'"}')
      expect(last_response.status).to eq 404 
    end

    it 'should check node status' do
      uri = URI('https://switcher-load-balance.herokuapp.com/switcher-balance/check')
      stub_request(:get, "https://switcher-load-balance.herokuapp.com/switcher-balance/check").
         with(
           headers: {
            'Accept'=>'*/*',
            'Host'=>'switcher-load-balance.herokuapp.com',
            'User-Agent'=>'Ruby'
           }).
         to_return(status: 200, 
          body: '{
                    "message":"All good",
                    "code":200,
                    "online":[
                      {
                        "name":"SNODE1",
                        "uri":"https://switcher-api.herokuapp.com",
                        "check_endpoint":
                        "/check","status":true
                      }],
                    "offline":[]}', headers: {})

      get '/cmd', :token => "$up3r$s3kr3t", :text => "status"
      expect(last_response).to be_ok
      expect(last_response.status).to eq 200
    end

    it 'should execute check with success' do
      # Auth mock
      stub_request(:post, "https://switcher-load-balance.herokuapp.com/criteria/auth").
         with(
           body: "{\"domain\":\"Switcher API\",\"component\":\"Slack\",\"environment\":\"default\"}",
           headers: {
            'Accept'=>'*/*',
            'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'Content-Type'=>'application/json',
            'User-Agent'=>'Ruby'
           }).
           to_return(status: 200, 
           body: '
             {
               "token":"blah-blah-blah",
               "exp":1587436952
             }', headers: {})

      # API mock
      stub_request(:post, "https://switcher-load-balance.herokuapp.com/criteria?bypassMetric=true&key=FEATURE01&showReason=true&showStrategy=false").
         with(
          body: "{\"entry\":[{\"strategy\":\"VALUE_VALIDATION\",\"input\":\"Roger\"}]}",
           headers: {
            'Accept'=>'*/*',
            'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'Authorization'=>'Bearer blah-blah-blah',
            'Content-Type'=>'application/json',
            'User-Agent'=>'Ruby'
           }).
           to_return(status: 200, 
           body: '
             {
               "strategies":[
                 {
                   "values":["Roger","Sohee"],
                   "description":"Allowed users",
                   "strategy":"VALUE_VALIDATION",
                   "operation":"EXIST",
                   "activated":{"default":true}}],
                   "result":true,
                   "reason":"Success"
                 } ', headers: {})

      get '/cmd', :token => "$up3r$s3kr3t", :text => "check-prd FEATURE01 -v Roger"
      expect(last_response).to be_ok
      expect(last_response.status).to eq 200
    end
  end
end