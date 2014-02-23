#!/bin/bash

CLC_DIR=/home/clc3123/chenlichao

source /usr/local/rvm/environments/$(cat $CLC_DIR/.ruby-version)

cd $CLC_DIR && rake submit_sitemap
