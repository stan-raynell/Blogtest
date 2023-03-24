FROM ruby:3.1.2-alpine AS builder
RUN apk update && apk upgrade
RUN apk add build-base
COPY Gemfile* .
RUN gem install bundler
RUN bundle install
FROM ruby:3.1.2-alpine AS runner
RUN apk update && apk upgrade
RUN apk add \
tzdata \
nodejs \
sqlite
WORKDIR /app
COPY --from=builder /usr/local/bundle/ /usr/local/bundle/
EXPOSE 3000
CMD [ "rails", "server", "-b", "0.0.0.0" ]