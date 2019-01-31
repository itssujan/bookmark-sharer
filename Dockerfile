FROM ruby:2.6.0

LABEL maintainer="Sujan Abraham <itssujan@gmail.com>"

RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client

ENV RAILS_ROOT /app/
#RUN mkdir -p $RAILS_ROOT
WORKDIR $RAILS_ROOT

COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock

RUN bundle check || bundle install

COPY . .
EXPOSE 3000

#Database
COPY ./config/database.yml ./config/database.yml

CMD bundle exec puma -c config/puma.rb
