#!/usr/bin/env puma

directory '/work/www/x/current'
rackup '/work/www/x/current/config.ru'
environment 'production'

pidfile '/work/www/x/shared/tmp/pids/puma.pid'
state_path '/work/www/x/shared/tmp/pids/puma.state'
stdout_redirect '/work/www/x/shared/log/puma_access.log', '/work/www/x/shared/log/puma_error.log', true

threads 0,8

bind 'unix:///work/www/x/shared/socket/x.sock'
workers 2


on_restart do
  puts 'Refreshing Gemfile'
  ENV['BUNDLE_GEMFILE'] = '/work/www/x/current/Gemfile'
end

prune_bundler
