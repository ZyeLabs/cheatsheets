FROM ruby:2.5.3

# RUN apt-get install -qq curl software-properties-common
RUN curl -sL http://deb.nodesource.com/setup_11.x | bash -
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get update -qq && apt-get install -qq --no-install-recommends \
    nodejs \
    yarn \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /app
WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN gem install bundler && bundle install --without development test --jobs 10 --retry 5

COPY . ./

EXPOSE 3000
CMD ["foreman", "start"]
# CMD ["bundle", "exec", "jekyll", "serve", "--port", "3000"]