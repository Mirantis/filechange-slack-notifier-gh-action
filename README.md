# Filechange Slack Notifier

This action allows the user to send custom Slack notifications based on repo path changes


## Inputs

## `slack-webhook-url`

**Required** The SLACK_WEBHOOK_URL which is associated with the SLACK channel you want to post to.

## `slack-channel-name`

**Required** The channel name where you want to post the message to.

## `message-title`

**Required** The title of the message.

## `message`

**Required** The message to post.

## `notify-users`

**Required** The users to be notified via @ tag in the message.

## `message-color`

**Required** The color of the message in hex format.

## Usage

```yaml
name: Notify on Slack on subscribed folder
on: 
  pull_request:
    paths:
      - 'test/*'
jobs:
  my_job:
    runs-on: ubuntu-latest
    steps:
      - name: Subscribe to Path - TEAM 1
        uses: mirantis/sub-to-path@v1
        with:
          slack-webhook-url: ${{ secrets.SLACK_WEBHOOK_URL }}
          slack-channel-name: "test-channel"
          message-title: "Test TITLE"
          message: "Test action"
          notify-users: "@testuser"
```
