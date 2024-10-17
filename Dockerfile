FROM golang:1.23.0 AS build

ARG TESLA_VERBOSE
ARG TESLA_HTTP_PROXY_HOST
ARG TESLA_HTTP_PROXY_PORT
ARG TESLA_HTTP_PROXY_TLS_CERT
ARG TESLA_HTTP_PROXY_TLS_KEY
ARG TESLA_KEY_FILE

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . .

RUN mkdir build
COPY ./config/ ./build/config
RUN go build -o ./build ./...

FROM gcr.io/distroless/base-debian12 AS runtime

COPY --from=build /app/build /usr/local/bin

EXPOSE 443
ENTRYPOINT ["tesla-http-proxy"]
