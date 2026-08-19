FROM ruby:2.5-alpine

WORKDIR /app

COPY . /app

RUN apk update && apk upgrade \
    && apk add pdftk \
    && gem install bundler \
    && apk add git openssh-client pdftk musl-dev make g++ \
    && bundle install

EXPOSE 4567
