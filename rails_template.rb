gem 'puma'
gem 'bootstrap-sass', '~> 3.3.3'
gem 'httparty'
gem 'hamlit'
gem 'therubyracer', platforms: :ruby
gem "haml-rails", "~> 0.9"

gem_group(:development, :test) do
    gem 'byebug'
    gem 'binding_of_caller'
    gem 'better_errors'
    gem 'quiet_assets'
    gem 'annotate'
end

gem_group(:test) do
  gem "rspec"
  gem "rspec-rails"
  gem "capybara"
  gem "database_cleaner"
  gem "spring-commands-rspec"
  gem 'webmock'
  gem 'poltergeist'
  gem 'faker'
end

run 'bundle'


generate "rspec:install"

gsub_file "spec/rails_helper.rb",
  "config.use_transactional_fixtures = true",
  "config.use_transactional_fixtures = false"

insert_into_file "spec/rails_helper.rb",
  after: "config.use_transactional_fixtures = false\n" do
  <<-CONTENT

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
  CONTENT
end
