
# Test Review

## Dependencies (Process for Mac OS)

- PostgreSQL database -> brew install postgresql@15
- chromedriver -> brew install chromedriver
- redis -> brew install redis
- ruby 3.0.3 -> can be installed via rvm or rbenv
- bundler -> gem install bundler


## Setup

- Clone the project
- apply bundle install for downloading all gems
- Set the following ENV variables (check config/database.yml for defaults):
    - POSTGRES_USER
    - POSTGRES_PASSWORD
    - POSTGRES_HOST
    - POSTGRES_PORT
- make sure redis is running -> run `redis-server`
- execute `bundle exec rake db:setup` for setting up database
    - a testing user is provided -> email: `test@test.com` password: `123456`
- run `bundle exec sidekiq`
- run `bundle exec rails s`