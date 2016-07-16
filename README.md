# Rationale

Many projects keep their knowledge base in GitHub wiki. Many of us use Slack. Some of us would like to be notified when pages are being created/edited, and unfortunately this is not supported by GitHub.

GitHub Webhook is not format compatible with Slack Webhook handler.

# Synopsis

This project is a shim between GitHub Webhook and Slack Webhook handler performing a trivial JSON transformation that on a free Heroku tier.

# Installation

## Deploy gollum-slack application to Heroku

    git clone git@github.com:pirj/gollum-slack.git
    cd gollum-slack
    heroku create
    git push heroku master
    WEBHOOK_PATH=$(base64 /dev/urandom | tr -d 'A-Z/+' | head -c 32)
    heroku config:set WEBHOOK_PATH=$WEBHOOK_PATH

## Set up Slack incoming webhook

## Point gollum-slack to your Slack webhook handler

    heroku config:set SLACK_URI=https://hooks.slack.com/services/BLAH/BLAH/WOOBAHDOOBAH

## Point GitHub to gollum-slack application

Use URL that consists of 'Web URL' from `heroku info` and path from `echo $WEBHOOK_URL`

## Override default notification template

### Slack webhook handler format

Basically Slack is expecting webhook in the following format:

    {
      "text": "New Help Ticket Received: http://domain.com/ticket/123456"
    }

More information here: https://api.slack.com/custom-integrations

### Default template

    #{sender.login} has #{pages.first.action} page '#{pages.first.title}' at #{pages.first.html_url}

Usually resulting in something like

    pirj has created page 'Home' at https://github.com/pirj/gollum-slack/wiki/Home

### Gollum webhook format

https://developer.github.com/v3/activity/events/types/#gollumevent

# Gotchas

No, there is no event for page delete.

No, Edit Message is not in payload.

There is a SHA-1 of this revision in payload, but there is no link to compare this to previous revision, and previous revision SHA-1 is not in payload.
