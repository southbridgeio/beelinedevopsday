# frozen_string_literal: true

Airbrake.configure do |config|
  config.host = 'https://errbit.southbridge.io'
  config.project_id = 2 # required, but any positive integer works
  config.project_key = Rails.application.secrets.errbit_project_key || 'anykey'
  config.environment = Rails.env
  config.ignore_environments = %w(development test production)
end
