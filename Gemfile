source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 5.0.1'
gem 'pg'
gem 'puma', '~> 3.0'

gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'jbuilder', '~> 2.5'

group :development, :test do
  gem 'byebug'
  gem 'capistrano-rails'
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.0.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

gem 'jquery-rails'
gem 'gentelella-rails' #, path: "../gentelella-rails"
gem 'modernizr-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Devise & CanCanCan
gem 'devise'
gem 'cancancan'

# Foreman
gem 'foreman'

# Haml
gem 'haml'

# Monetize
gem 'money-rails'

# Enumerize
gem 'enumerize'

# Nokogiri
gem 'nokogiri'

# MetaTags
gem 'meta-tags'

# Editor
gem 'bootstrap-wysihtml5-rails'

# Twitter
gem 'twitter'

# Google Shortener
gem 'google_url_shortener'

# SiteMap
gem 'sitemap'