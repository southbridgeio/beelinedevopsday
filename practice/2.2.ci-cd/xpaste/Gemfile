source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2'

gem 'pg', '~> 0.21'
gem 'paranoia'

# cron

gem 'rufus-scheduler', '~> 3.4.0'
gem 'fugit'
gem "sidekiq-cron", "~> 0.6.3"

# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
gem 'semantic-ui-sass'
gem 'clipboard-rails'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
# gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use puma as the app server
gem 'puma'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'
  gem 'binding_of_caller', '>= 0.8.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  # gem 'spring'
  gem 'annotate'

  # Use Capistrano for deployment
  gem 'capistrano-rails'
  gem 'capistrano-rvm'
  gem 'capistrano3-puma'

  gem 'pry-rails'
  gem 'pry-byebug'
  gem 'listen'
end

gem 'enumerize'
gem 'redcarpet'
gem 'russian'
gem 'http_accept_language'
gem 'airbrake', '~> 5.0'
gem 'bootsnap', '>= 1.1.0', require: false

group :test do
  gem 'database_cleaner'
  gem 'webmock', '~> 2.3.1'

  gem 'capybara-screenshot'
  gem 'timecop'
  gem 'capybara'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'rspec-rails'
end
