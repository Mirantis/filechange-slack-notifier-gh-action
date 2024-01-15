#!/bin/bash

# Set the variables
SLACK_WEBHOOK_URL=$1
SLACK_CHANNEL_NAME=$2
MESSAGE_TITLE=$3
MESSAGE=$4
NOTIFY_USERS=$5
MESSAGE_COLOR=$6

# Extract repository URL from the GitHub event JSON
REPO_URL=$(jq --raw-output '.pull_request.base.repo.html_url' "$GITHUB_EVENT_PATH")

# Get the pr status from the GitHub event JSON
PR_STATUS=$(jq --raw-output '.action' "$GITHUB_EVENT_PATH")

# Get the author of the pull request from the GitHub event JSON
GITHUB_USER=$(jq --raw-output '.pull_request.base.user.login' "$GITHUB_EVENT_PATH")

# Get the Pull Request URL from the GitHub event JSON
PR_URL=$(jq --raw-output '.pull_request._links.html.href' "$GITHUB_EVENT_PATH")

format_notify_users() {
    # Convert NOTIFY_USERS into an array based on space as delimiter
    IFS=' ' read -r -a NOTIFY_USERS_ARRAY <<< "$NOTIFY_USERS"
    TEMP_USERS=''
    for user in "${NOTIFY_USERS_ARRAY[@]}"; do
        TEMP_USERS+="<${user}> "
    done
    NOTIFY_USERS=$TEMP_USERS
}

format_notify_users

# Send a Slack notification
send_slack_notification() {
    local payload=$(cat <<PAYLOAD
    {
        "channel": "${SLACK_CHANNEL_NAME}",
        "attachments": [
        {
            "color": "${MESSAGE_COLOR}",
            "title": "${MESSAGE_TITLE}",
            "text": "${MESSAGE}"
        }
        ],
        "blocks":[
        {
        "type":"section",
            "text":{
                "type":"mrkdwn",
                "text":"*Repository:* ${REPO_URL}"
            }
        },
        {
        "type":"section",
            "text":{
                "type":"mrkdwn",
                "text":"*PR Status:* ${PR_STATUS}"
            }
        },
        {
        "type":"section",
            "text":{
                "type":"mrkdwn",
                "text":"*Author:* ${GITHUB_USER}"
            }
        },
        {
        "type":"section",
            "text":{
                "type":"mrkdwn",
                "text":"<${PR_URL}|View Pull Request>"
            }
        },
        {
        "type":"section",
            "text":{
                "type":"mrkdwn",
                "text":"${NOTIFY_USERS}"
            }
        }
        ]
    }
PAYLOAD
)
    curl -X POST -H 'Content-type: application/json' --data "${payload}" ${SLACK_WEBHOOK_URL}
}

send_slack_notification
