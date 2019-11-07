#!/bin/sh

bundle exec rails runner "Sidekiq::Cron::Job.destroy_all!"
bundle exec rails runner "Sidekiq::Cron::Job.load_from_hash(YAML.load_file('config/schedule.yml'))"
bundle exec sidekiq --index 0 --environment production --pidfile /tmp/sidekiq.pid -q cron