FROM ruby:2.6.4-alpine3.10

RUN apk update
RUN apk add --no-cache bash nodejs postgresql
RUN mkdir /app

WORKDIR /app

COPY Gemfile Gemfile.lock /app/

RUN gem install bundler
RUN apk add --no-cache alpine-sdk \
    --virtual .build_deps libxml2-dev libxslt-dev zlib zlib-dev postgresql-dev readline-dev
RUN bundle install
RUN bundle exec rails webpacker:install

COPY . /app

CMD ["bash"]
