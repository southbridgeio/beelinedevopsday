FROM ruby:2.6.0-alpine3.7

ENV WEB_PORT 80
ENV BUILD_PACKAGES nginx nodejs dcron tzdata postgresql-dev libxslt-dev
ENV BUILD_TMP_PACKAGES build-base libxml2-dev

WORKDIR /app
ENV HOME /app

RUN set -ex && \
    addgroup -S www-data && \
    adduser -S www-data -G www-data && \
    apk --update add --no-cache $BUILD_PACKAGES && \
    ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log && \
    rm -rf /var/cache/apk/*

COPY config/nginx.conf /etc/nginx/nginx.conf

COPY Gemfile Gemfile.lock ./
RUN set -ex && \
    apk add --no-cache --virtual build_deps $BUILD_TMP_PACKAGES && \
    bundle config build.nokogiri --use-system-libraries && \
    bundle install --clean --no-cache --without development && \
    rm -rf /var/cache/apk/* && \
    apk del build_deps

COPY . .
RUN SECRET_KEY_BASE=jkdf8xlandfkzz99alldlmernzp2mska7bghqp9akamzja7ejnq65ahjnfj RAILS_ENV=production bundle exec rake assets:precompile

RUN chown -R www-data:www-data /app/public

EXPOSE $WEB_PORT

CMD ["./bin/docker-entrypoint.sh"]
