source "https://rubygems.org"

gem "fastlane"
gem "dotenv"

group :development, :test do
  gem 'pry'
  gem 'rb-readline'
end
plugins_path = File.join(File.dirname(__FILE__), 'fastlane', 'Pluginfile')
eval_gemfile(plugins_path) if File.exist?(plugins_path)
