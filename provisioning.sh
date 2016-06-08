#!/bin/sh

set -ex

if [ ! -f minecraft_server.jar ]; then
  curl -LSfs https://s3.amazonaws.com/Minecraft.Download/versions/1.9.4/minecraft_server.1.9.4.jar -o minecraft_server.jar
fi

bundle check --path=.bundle || bundle install --path=.bundle
bundle exec serverkit apply --hosts minecraft recipe.yml
