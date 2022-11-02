#!/bin/sh

bundle exec rake db:migrate
puma config.ru -C puma.rb
