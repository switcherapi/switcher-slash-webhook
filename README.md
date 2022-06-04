***

<div align="center">
<b>Switcher Slash Webhook</b><br>
A Slash Add-on App for Slack
</div>

<div align="center">

[![Master CI](https://github.com/switcherapi/switcher-slash-webhook/actions/workflows/master.yml/badge.svg)](https://github.com/switcherapi/switcher-slash-webhook/actions/workflows/master.yml)
[![Coverage Status](https://coveralls.io/repos/github/switcherapi/switcher-slash-webhook/badge.svg?branch=master)](https://coveralls.io/github/switcherapi/switcher-slash-webhook?branch=master)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Slack: Switcher-HQ](https://img.shields.io/badge/slack-@switcher/hq-blue.svg?logo=slack)](https://switcher-hq.slack.com/)

</div>

***

![Switcher API: Cloud-based Feature Flag API](https://github.com/switcherapi/switcherapi-assets/blob/master/logo/switcherapi_grey.png)

# Requirements  
- Ruby (Sinatra) 1.3 (Release 2.2.x)
- Slash add-on for Slack
- Coffee =D

# About  
**Switcher Slash Webhook** is a API wrapper used to check both Switcher Load Balance and Switcher API from the Slack app using Slash Command add-on.

# Installing/Running

### Setup the environment
Changes on *config/development.yaml* file.
```
slack_hook_endpoint: [SLACK_HOOK_URL]
slack_hook_token: [SLACK_API_KEY]
switcher_load_balance: https://switcher-load-balance.herokuapp.com
switcher_api_key: [SWITCHER_COMPONENT_KEY]
switcher_api_domain: [SWITCHER_DOMAIN_NAME]
```

### Running
> bundle install
> rackup -p 4567

### Testing
> rspec


* * *


# Usage

### Request - status (GET)
```
{{url}}/cmd?token=SLASH_CMD_TOKEN&text=status
```
### Response
```json
{
    "blocks": [
        {
            "type": "section",
            "text": {
                "type": "mrkdwn",
                "text": "Switcher Load Balance\n\n*Message:* All good\n*Code:* 200\n"
            },
            "accessory": {
                "type": "image",
                "image_url": "https://raw.githubusercontent.com/s/switcherapi-assets/master/logo/switcher_mark_grey.png",
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
                "text": "*Node:* SNODE1 :sunny:\n*Endpoint:* https://switcher-api.herokuapp.com\n*Status:* online"
            }
        }
    ]
}
```
![Sample: status cmd](https://raw.githubusercontent.com/switcherapi/switcher-slash-webhook/master/asset/sample_status.jpg)

### Request - check API (GET)
```
{{url}}/cmd?token=SLASH_CMD_TOKEN&text=check-prd+FEATURE01+-v+Roger
```
### Response
```json
{
    "blocks": [
        {
            "type": "section",
            "text": {
                "type": "mrkdwn",
                "text": "Switcher API\n\n*Result:* Passed\n*Reason:* Success\n"
            },
            "accessory": {
                "type": "image",
                "image_url": "https://raw.githubusercontent.com/switcherapi/switcherapi-assets/master/logo/switcher_mark_grey.png",
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
                "text": "*Command:* /cmd check-prd FEATURE01 -v Roger"
            }
        }
    ]
}
```
![Sample: check API cmd](https://raw.githubusercontent.com/switcherapi/switcher-slash-webhook/master/asset/sample_checkapi.jpg)

# Contributing
Please do open an issue or PR if you feel you have something cool to add.