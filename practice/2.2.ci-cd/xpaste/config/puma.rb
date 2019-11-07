#!/usr/bin/env puma

# Puma config

# Configure "min" to be the minimum number of threads to use to answer
# requests and "max" the maximum.
#
# The default is "0, 16".
#
threads(1, (ENV['PUMA_MAX_THREADS'] || 4).to_i)

# === Cluster mode ===

# How many worker processes to run.  Typically this is set to
# to the number of available cores.
#
# The default is "0".
#
workers((ENV['PUMA_WORKERS'] || 0).to_i)

# Preload the application before starting the workers; this conflicts with
# phased restart feature. (off by default)

preload_app!

# Verifies that all workers have checked in to the master process within
# the given timeout. If not the worker process will be restarted. This is
# not a request timeout, it is to protect against a hung or dead process.
# Setting this value will not protect against slow requests.
# Default value is 60 seconds.
#
worker_timeout 60

# Change the default worker timeout for booting
#
# If unspecified, this defaults to the value of worker_timeout.
#
worker_boot_timeout 60

before_fork do
  ActiveSupport.on_load(:active_record) do
    ActiveRecord::Base.connection.disconnect!
  end
end

on_worker_boot do
  ActiveSupport.on_load(:active_record) do
    ActiveRecord::Base.establish_connection
  end
end
