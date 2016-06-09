#!/bin/sh

set -ex

if [ ! -f minecraft_server.jar ]; then
  curl -LSfs -o minecraft_server.jar https://s3.amazonaws.com/Minecraft.Download/versions/1.10/minecraft_server.1.10.jar
fi

bundle check --path=.bundle || bundle install --path=.bundle
bundle exec serverkit apply --log-level DEBUG --hosts minecraft recipe.yml
