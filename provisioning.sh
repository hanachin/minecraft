#!/bin/sh

set -ex

if [ ! -f files/minecraft_server.1.11.2.jar ]; then
  curl -LSfs -o files/minecraft_server.1.11.2.jar https://s3.amazonaws.com/Minecraft.Download/versions/1.11.2/minecraft_server.1.11.2.jar
fi

if [ -z $1 ]; then
  host='minecraft'
else
  host=$1
fi

bundle check --path=.bundle || bundle install --path=.bundle
bundle exec serverkit apply --log-level INFO --hosts $host --variables=variables.yml recipe.yml.erb
