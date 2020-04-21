[![Build Status](https://travis-ci.com/petruki/switcher-slash-webhook.svg?branch=master)](https://travis-ci.com/github/petruki/switcher-slash-webhook)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Slack: Switcher-HQ](https://img.shields.io/badge/slack-@switcher/hq-blue.svg?logo=slack)](https://switcher-hq.slack.com/)

![Switcher API: Cloud-based Feature Flag API](https://github.com/petruki/switcherapi-assets/blob/master/logo/switcherapi_grey.png)

# Requirements  
- Ruby (Sinatra)
- Slash add-on
- Coffee =D

# About  
**Switcher Slash Webhook** is a API wrapper used to invoke both Switcher Load Balance and Switcher API from the Slack using Slash Command add-on for Slack.

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
                "text": "*Node:* SNODE1 :sunny:\n*Endpoint:* https://switcher-api.herokuapp.com\n*Status:* online"
            }
        }
    ]
}
```
![Sample: status cmd](https://raw.githubusercontent.com/petruki/skimming/master/asset/sample_status.jpg)

### Request - check API (GET)
```
{{url}}/cmd?token=CrNvcww3ekLYgd1tfokVXwO1&text=check-prd+FEATURE01+-v+Roger
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
                "text": "*Command:* /cmd check-prd FEATURE01 -v Roger"
            }
        }
    ]
}
```
![Sample: check API cmd](https://raw.githubusercontent.com/petruki/skimming/master/asset/sample_checkapi.jpg)

# Contributing
Please do open an issue or PR if you feel you have something cool to add.