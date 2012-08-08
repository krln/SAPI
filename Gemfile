source 'https://rubygems.org'

gem 'rails', '3.2.7'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'rails-api'

gem 'pg'
gem 'pg_array_parser'
gem 'activerecord-postgres-hstore'
gem 'awesome_nested_set'
gem 'foreigner'
gem 'prawn'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'


# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'

group :staging, :production do
  gem 'exception_notification', :require => 'exception_notifier'
end

group :staging, :production, :development do
  # Link to MSSQL Server 2008
  gem 'tiny_tds'
end

group :development do
  gem 'immigrant'
  gem "guard-livereload"
  gem "yajl-ruby"
  gem "rack-livereload"
  gem "guard-bundler"
  gem 'annotate', :git => 'git://github.com/ctran/annotate_models.git'
  gem 'ruby-debug19'
  # Deploy with Capistrano
  gem 'capistrano'
  gem 'capistrano-ext'
  gem 'brightbox', '>=2.3.9'
  gem 'rack-cors', :require => 'rack/cors'
end

group :test, :development do
  gem "rspec-rails"
end

group :test do
  gem "factory_girl_rails", "~> 4.0"
end
