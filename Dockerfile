FROM ruby:latest

MAINTAINER Pascal Belouin <pbelouin@mpiwg-berlin.mpg.de>

RUN apt-get update && apt-get install -my wget gnupg && apt-get update && apt-get install -qq -y --no-install-recommends \
      build-essential libpq-dev libxml2-dev curl

# Node.js
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash - \
    && apt-get install -y nodejs

ENV INSTALL_PATH /rise_rp

RUN mkdir -p $INSTALL_PATH

WORKDIR $INSTALL_PATH

COPY Gemfile Gemfile.lock ./
COPY Gemfile Gemfile
RUN gem update --system
RUN gem install bundler
RUN bundle install
VOLUME ["$INSTALL_PATH/public"]

COPY . .

CMD puma -C config/puma.rb
