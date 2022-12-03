FROM rust

WORKDIR /app

COPY . .

ENV ROCKET_ADDRESS=0.0.0.0
ENV ROCKET_PORT=8000
ENV ROCKET_ENV=production

RUN rustup default nightly

EXPOSE 8000

CMD [ "cargo", "run" ]
