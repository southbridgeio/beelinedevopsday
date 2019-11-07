# frozen_string_literal: true

if ENV['REDIS_HOST'].present?
  Sidekiq.configure_server do |config|
    config.redis = {
      url: "redis://#{ENV['REDIS_HOST'] || 'localhost'}:#{ENV['REDIS_PORT'] || '6379'}/#{ENV['REDIS_DB_NUM'] || 4}",
      password: ENV['REDIS_PASSWORD']
    }
  end

  Sidekiq.configure_client do |config|
    config.redis = {
      url: "redis://#{ENV['REDIS_HOST'] || 'localhost'}:#{ENV['REDIS_PORT'] || '6379'}/#{ENV['REDIS_DB_NUM'] || 4}",
      password: ENV['REDIS_PASSWORD']
    }
  end
end
