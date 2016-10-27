From ruby:2.3.1-slim
MAINTAINER Steve Ellis <steve@smartcontract.com>

RUN apt-get update
RUN apt-get install -y build-essential libpq-dev libxml2-dev libxslt1-dev nodejs
RUN gem install bundler

# Bundler caching trick
WORKDIR /tmp
ADD Gemfile /tmp/
ADD Gemfile.lock /tmp/
RUN bundle install -j 4 --without development:test
RUN HOSTIP=`ip -4 addr show scope global dev eth0 | grep inet | awk '{print \$2}' | cut -d / -f 1`

ENV APP_HOME /nayru
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

ADD . $APP_HOME

CMD ["foreman", "start"]
