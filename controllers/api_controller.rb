class ApiController < Sinatra::Base

    @token
    @timeExp

    def self.command(settings, cmd)
        # Read & Validate command
        cmdFragments = validateCmd(cmd)

        if !@token or Time.now.to_i > @timeExp
            response = apiAuth(settings, cmdFragments[0])
            @token = JSON.parse(response)["token"]
            @timeExp = JSON.parse(response)["exp"]
        end

        apiResponse = apiCriteria(settings, cmdFragments[1], cmdFragments[2])
        Rack::Response.new(createPayload(apiResponse, cmd), 200, { 'Content-Type' => 'application/json' }).finish
    end

    # [0]: env - [1]: key - [2]: entry 
    def self.validateCmd(cmd)
        # URL: ?text=check-prd+FEATURE+-v+Roger,+-n+192.168.0.1
        # Slack: /cmd check-prd FEATURE -v Roger, -n 192.168.0.1
        begin
            cmdFragments = cmd.split(' ')

            env = cmdFragments[0].split('-')[1]
            key = cmdFragments[1]

            if cmdFragments.length() > 2
                entries = cmd.split(key)[1].split(',').map{ |x| x.strip }
            end

            if !env
                raise 'Environment not found'
            end

            if !key
                raise 'Key not found'
            end

            return env, key, entries
        rescue StandardError => e
            puts e.message
            Rack::Response.new(
                { text: "Invalid command - example: /cmd check-prd FEATURE Roger"}
                .to_json, 404, { 'Content-Type' => 'application/json' }).finish
        end
    end

    def self.apiAuth(settings, env)
        url = settings.switcher_load_balance + "/criteria/auth"
        uri = URI(url)

        https = Net::HTTP.new(uri.host, uri.port)
        https.use_ssl = true

        request = Net::HTTP::Post.new(uri.path)
        request['Content-Type'] = 'application/json'
        request['switcher-api-key'] = settings.switcher_api_key

        reqBody = {
            domain: settings.switcher_api_domain,
            component: "Slack",
            environment: env == 'prd' ? 'default' : env
        }
        request.body = reqBody.to_json

        response = https.request(request)
        response.body
    end

    def self.apiCriteria(settings, key, entries)
        url = settings.switcher_load_balance + "/criteria"
        uri = URI(url)

        request = Net::HTTP::Post.new(uri.path.concat("?showReason=true&showStrategy=false&bypassMetric=true&key=#{key}"))
        request['Content-Type'] = 'application/json'
        request['Authorization'] = "Bearer #{@token}"

        if entries
            reqEntries = JSON.parse('{ "entry": [] }')
            entries.each do |n|
                input = n.split(' ')
                entry = {
                    strategy: entryValidator(input[0]),
                    input: input[1]
                }
                reqEntries["entry"].push(entry)
            end
            request.body = reqEntries.to_json
        end
        
        https = Net::HTTP.new(uri.host, uri.port)
        https.use_ssl = true

        response = https.request(request)
        response.body
    end

    def self.entryValidator(flag)
        if flag == '-v'
            return 'VALUE_VALIDATION'
        elsif flag == '-n'
            return 'NETWORK_VALIDATION'
        elsif flag == '-t'
            return 'TIME_VALIDATION'
        elsif flag == '-d'
            return 'DATE_VALIDATION'
        end
    end

    def self.createPayload(apiResponse, cmd)
        jsonObj = JSON.parse(apiResponse)
        result = jsonObj["result"] ? 'Passed' : 'Failed'
        webhook_message = '{
            "blocks": [
                {
                    "type": "section",
                    "text": {
                        "type": "mrkdwn",
                        "text": "Switcher API\n\n*Result:* ' + result + '\n*Reason:* ' + jsonObj["reason"] + '\n"
                    },
                    "accessory": {
                        "type": "image",
                        "image_url": "https://raw.githubusercontent.com/petruki/switcherapi-assets/master/logo/switcher_mark_grey.png",
                        "alt_text": "Switcher API"
                    }
                },
                {
                    "type": "divider"
                },
                {
                    "type": "section",
                    "text": {
                        "type": "mrkdwn",
                        "text": "*Command:* /cmd ' + cmd + '"
                    }
                }
            ]
        }'
        return JSON.parse(webhook_message).to_json
    end
  
end