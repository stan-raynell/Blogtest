FROM ruby:3.2.1
RUN apt-get update
RUN apt-get install -y yarnpkg
RUN ln -s /usr/bin/yarnpkg /usr/local/bin/yarn
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client
WORKDIR /blog
COPY Gemfile /blog/Gemfile
COPY Gemfile.lock /blog/Gemfile.lock
RUN gem install bundler
RUN bundle install