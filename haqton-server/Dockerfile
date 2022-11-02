FROM ruby:2.7.6-alpine

LABEL maintainer="sandroandrade@kde.org"

RUN apk update && \
    apk upgrade && \
    apk add build-base mariadb-dev sqlite-dev libzmq && \
    rm -rf /var/cache/apk/* && \
    ln -s /usr/lib/libzmq.so.5 /usr/lib/libzmq.so

# Set environment variables.
ENV HOME /var/app

# Define working directory.
COPY . /var/app
RUN cd /var/app && bundle install

WORKDIR /var/app

EXPOSE 4001

CMD ["/bin/sh", "/var/app/bin/start.sh"]
