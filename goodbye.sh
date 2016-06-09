#!/bin/sh

source /home/mc/.envrc

if [ -n "$(service minecraft command "list" | grep 'There are 0')" ]; then
  curl -H "x-api-key: $X_API_KEY" -X DELETE $ENDPOINT_URL
fi
