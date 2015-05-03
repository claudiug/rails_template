gem 'puma'
gem 'bootstrap-sass', '~> 3.3.3'
gem 'httparty'
gem 'hamlit'
gem 'therubyracer', platforms: :ruby
gem "haml-rails", "~> 0.9"

gem_group(:development, :test) do
    gem 'byebug'
    gem 'awesome_print'
    gem 'binding_of_caller'
    gem 'better_errors'
    gem 'quiet_assets'
    gem 'annotate'
    gem 'spring-commands-rspec'
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
  gem 'factory_girl_rails'
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

insert_into_file "config/application.rb",
after: "config.active_record.raise_in_transactional_callbacks = true\n" do
  <<-CONTENT
  config.generators do|g|
        g.test_framework :rspec,
          fixtures: true,
          view_specs: false,
          helper_specs: false,
          routing_specs: true,
          controller_specs: true,
          request_specs: false
        g.fixture_replacement :factory_girl, dir: "spec/factories"
      end
  CONTENT
end

