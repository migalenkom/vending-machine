source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.2'

gem 'active_model_serializers'
gem 'bcrypt'
gem 'bootsnap', '>= 1.4.4', require: false
gem 'puma', '~> 5.0'
gem 'rails', '~> 6.1.4', '>= 6.1.4.4'
gem 'sqlite3', '~> 1.4'
group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'factory_bot_rails' # Nice to be able to generate records in pry
  gem 'faker'
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'rspec-core'
  gem 'rspec-expectations'
  gem 'rspec-mocks'
  gem 'rspec-rails'
  gem 'rspec-support'
  gem 'rubocop-rails', require: false
end

group :development do
  gem 'listen', '~> 3.3'
  gem 'spring'
end

gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
