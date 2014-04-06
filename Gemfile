source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails'

group :development do
  # Use sqlite3 as the database for Active Record
  gem 'sqlite3'
  gem "nifty-generators"
  gem 'populator'
  gem 'faker'
  gem 'annotate', ">=2.6.0"

  # Use Capistrano for deployment
  gem 'capistrano'

  # rails specific capistrano funcitons
  gem 'capistrano-rails', '~> 1.1.0'

  # integrate bundler with capistrano
  gem 'capistrano-bundler'

  # if you are using RBENV
  gem 'capistrano-rbenv', "~> 2.0"

  gem 'capistrano3-unicorn'
end

group :production do
  gem 'pg'
  gem 'rails_12factor'
end


gem 'will_paginate'

gem 'devise'
gem 'omniauth-github'

# markdown / syntax highlighting
gem 'pygments.rb'
gem 'redcarpet'
gem 'albino'
gem 'nokogiri'

gem "octokit", "~> 2.0"

# renames models
# gem 'rename'

# text editors
gem 'ace-rails-ap'

group :assets do

  # Use SCSS for stylesheets
  gem 'sass-rails', '~> 4.0.0'

  # Sass Compass
  gem 'compass-rails'

  # Use Uglifier as compressor for JavaScript assets
  gem 'uglifier', '>= 1.3.0'

  # Use CoffeeScript for .js.coffee assets and views
  gem 'coffee-rails', '~> 4.0.0'

end

# Use jquery as the JavaScript library
gem 'jquery-rails'


# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby


# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# Use unicorn as the app server
gem 'unicorn'

# Use debugger
# gem 'debugger', group: [:development, :test]

gem "mocha", group: :test
