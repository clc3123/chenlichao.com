#!/bin/bash

CLC_DIR=/home/chenlichao/chenlichao

source /usr/local/rvm/environments/$(cat $CLC_DIR/.ruby-version)

cd $CLC_DIR && rake submit_sitemap
