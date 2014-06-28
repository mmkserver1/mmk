source 'http://rubygems.org'

gem 'rails', '3.1.1'
gem 'rake'

gem 'rails_autolink'
gem 'devise'
gem 'json'
gem 'delayed_job'
gem 'yajl-ruby'
gem 'activeadmin'
gem 'carrierwave'
gem 'rails_config'

group :assets do
  gem 'coffee-rails', "~> 3.1.1"
  gem 'uglifier', '>= 1.0.3'
end

gem 'sass-rails', "~> 3.1.4" # Moved out of assets group because it is strictly required by ActiveAdmin
gem 'jquery-rails'
gem 'haml'

group :production, :staging do
  gem 'unicorn'
  gem 'mysql2'
  gem 'exception_notification', :require => 'exception_notifier'
  gem 'whenever'

  # Backup
  gem 'backup'
  gem 'aproxacs-s3sync' # Ruby 1.9.x compatible only! With Ruby 1.8.x should use s3sync gem.
  gem 'fog', '>= 0.11.0'
end

group :development, :test do
  gem 'rails-dev-tweaks', '~> 0.5.1' # App drives faster in development now.
  gem 'capistrano'
  gem 'capistrano-ext'
  gem 'capybara'
  gem 'factory_girl_rails'
  gem 'rspec-rails'
  gem 'sqlite3', :platforms => [:mingw, :ruby]
end