#!/bin/sh

source /home/mc/.envrc

curl -X POST https://maker.ifttt.com/trigger/boot/with/key/$IFTTT_MAKER_KEY
