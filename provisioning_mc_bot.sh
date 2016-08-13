#!/bin/sh

set -ex

if [ -z $1 ]; then
  host='mc_bot'
else
  host=$1
fi

bundle check --path=.bundle || bundle install --path=.bundle
bundle exec serverkit apply --log-level INFO --hosts $host mc_twitter_bot/recipe.yml
