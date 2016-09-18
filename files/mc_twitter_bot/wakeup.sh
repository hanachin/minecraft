#!/bin/sh

set -ex

if [ -z "$(/sbin/service mc_twitter_bot status | grep 'is running')" ]; then
  sudo /sbin/service mc_twitter_bot start >> /home/ec2-user/wakeup.log
fi
