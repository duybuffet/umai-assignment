# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

### Install Ruby
```
$ rbenv install 3.0.0
$ ruby -v
ruby 3.0.0p0 (2020-12-25 revision 95aff21468) [x86_64-darwin18]
```

### Install bundler, Prepare the Database, Start the App
- Install bundler
```
$ gem install bundler -v 2.2.26
```

- Bundle install
```
$ bundle install
```

- Prepare the database

Install postgres

https://www.postgresql.org/docs/current/tutorial-install.html

Create new config file
```
$ cp db/config.yml.example db/config.yml
```

Edit the necessary fields corresponding to your local postgres database

Running migrate script, seeding
```
$ rake db:setup
```

- Start the app
```
$ rackup config.ru
```

### Running worker
Open a new terminal tab or a new terminal, go to the project and run the following command
```
$ sidekiq -r ./worker.rb
```

### Running unit test with rspec
```
$ rspec spec/
```
