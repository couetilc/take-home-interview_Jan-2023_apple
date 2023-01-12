FROM ruby

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        postgresql-client \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/app
ENV PATH="${PATH}:/usr/src/app/bin"
COPY Gemfile* ./
ENV BUNDLE_PATH=/bundle
RUN bundle install --full-index
COPY . .

EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]
