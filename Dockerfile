FROM ruby:2.5.0-stretch as builder

RUN apt-get update && apt-get install -y nodejs \
&& apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY config.rb .
COPY font-selection.json .
COPY Gemfile .
COPY Gemfile.lock .
COPY source ./source/
COPY lib ./lib/
RUN bundle install
RUN bundle exec middleman build --clean

FROM nginx:1.13.9

COPY --from=builder /app/build /usr/share/nginx/html/


