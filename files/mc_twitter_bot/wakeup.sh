#!/bin/sh

set -ex

if [ -z "$(/sbin/service mc_twitter_bot status | grep 'is running')" ]; then
  /sbin/service mc_twitter_bot start
fi
