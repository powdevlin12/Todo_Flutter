source 'https://rubygems.org'

# You may use http://rbenv.org/ or https://rvm.io/ to install and use this version
ruby '2.7.8'

gem 'fastlane', '= 2.220.0'
gem 'cocoapods', '= 1.15.0'
gem 'rake'
gem 'json', '2.1.0'
gem 'nokogiri', '1.12.5'

plugins_path = File.join(File.dirname(__FILE__), 'fastlane', 'Pluginfile')
eval_gemfile(plugins_path) if File.exist?(plugins_path)