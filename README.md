# VADO

* Ruby version - 3.3.0

* System dependencies

  - Ruby v3.3.0
  - PostgreSQL v15.5

* Configuration

 ```bash
  bundle install
  bin/rails db:setup
  bin/rails s
 ```

* Database creation

```bash
  bin/rails db:create
  bin/rails db:migrate
```

* How to run the test suite

```bash
  bundle exec rspec
```

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

## Planned & Done

- [x] Message creation
- [x] Integration with language model GPT
- [x] Response builder
- [x] Speech to Text conversion
- [x] Text to Speech conversion
- [x] Integration with weather API
- [x] Google oauth implementation (Google calendar)
- [x] Integration with google calendar
- [x] Integration with google maps
- [ ] Integration with gmail
- [ ] Notifications implementation

