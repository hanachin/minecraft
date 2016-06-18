#!/bin/sh

source /home/mc/.envrc

date >> /tmp/goodbye

if [ -n "$(/sbin/service minecraft command 'list' | grep 'There are 0')" ]; then
  echo 'wait 180 seconds...'
  sleep 180
  if [ -n "$(/sbin/service minecraft command 'list' | grep 'There are 0')" ]; then
    echo 'shut down server'
    /sbin/service minecraft stop
    curl -X POST https://maker.ifttt.com/trigger/stop/with/key/$IFTTT_MAKER_KEY
    curl -H "x-api-key: $X_API_KEY" -X DELETE $ENDPOINT_URL
  fi
fi
