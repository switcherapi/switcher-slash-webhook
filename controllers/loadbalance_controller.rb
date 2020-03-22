class LoadBalanceController < Sinatra::Base

    def self.command(settings)
        url = settings.switcher_load_balance + "/switcher-balance/check"
        uri = URI(url)
        api_response = Net::HTTP.get(uri)
        api_res_obj = JSON.parse(api_response)

        # Read API response
        message = api_res_obj["message"]
        code = api_res_obj["code"]
        online = api_res_obj["online"]
        offline = api_res_obj["offline"]
        
        responsePayload = createPayload(api_res_obj["message"], api_res_obj["code"], api_res_obj["online"], api_res_obj["offline"])
        Rack::Response.new(responsePayload, 200, { 'Content-Type' => 'application/json' }).finish
    end

    def self.createPayload(message, code, online, offline)
        webhook_message = '{
            "blocks": [
                {
                    "type": "section",
                    "text": {
                        "type": "mrkdwn",
                        "text": "Switcher Load Balance\n\n*Message:* ' + message + '\n*Code:* ' + code.to_s + '\n"
                    },
                    "accessory": {
                        "type": "image",
                        "image_url": "https://raw.githubusercontent.com/petruki/switcherapi-assets/master/logo/switcher_mark_grey.png",
                        "alt_text": "Switcher API"
                    }
                },
                {
                    "type": "divider"
                }
            ]
        }'

        jsonMessage = JSON.parse(webhook_message)
        online.each do |n|
            node_section = {
                type: "section",
                text: {
                    type: "mrkdwn",
                    text: "*Node:* #{n["name"]} :sunny:\n*Endpoint:* #{n["uri"]}\n*Status:* #{n["status"] ? 'online' : 'offline'}"
                }
            }
            jsonMessage["blocks"] << node_section
        end

        offline.each do |n|
            node_section = {
                type: "section",
                text: {
                    type: "mrkdwn",
                    text: "*Name:* #{n["name"]} :new_moon:\n*Endpoint:* #{n["uri"]}\n*Status:* #{n["status"] ? 'online' : 'offline'}"
                }
            }
            jsonMessage["blocks"] << node_section
        end

        return jsonMessage.to_json
    end
  
end