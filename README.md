# Get start

- `git clone git@github.com:chinlan/user_registration_system.git`
- `cd user_registration_system`
- Copy the `.env.sample` file content to `.env` (Since this is a demo project, I put all the info into sample file for convenience)
- `docker-compose build`
- `docker-compose up`
- Open a new terminal window, and run `docker-compose exec app bash`
- When entering bash, run `bundle exec rails db:setup`
- Open `localhost:3000` in the browser

# Run test suite
- `docker-compose exec app bash`
- When entering bash, run `bundle exec rspec`

# Preview the mail
- Visit `localhost:3000/rails/mailers`

# View mail sent in the development environment
- /tmp/letter_opener/*
