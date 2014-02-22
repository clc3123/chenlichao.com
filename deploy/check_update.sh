#!/bin/bash

CLCAPP_DIR=/home/chenlichao/chenlichao

source /usr/local/rvm/environments/$(cat $CLCAPP_DIR/.ruby-version)

cd $CLCAPP_DIR
git pull origin master
CLCAPP_MOST_RECENT_COMMIT=$(git log --pretty=oneline | head -n 1 | cut -d ' ' -f 1)
if [[ ! ( -s .most_recent_commit && $(cat .most_recent_commit) == $CLCAPP_MOST_RECENT_COMMIT ) ]]
then
  rm -rf _site
  bundle exec jekyll build --config _config.yml,_config_production.yml
  echo $CLCAPP_MOST_RECENT_COMMIT > .most_recent_commit
  rake sitemap
fi
