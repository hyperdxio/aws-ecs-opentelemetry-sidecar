# Ref: https://github.com/open-telemetry/opentelemetry-collector-releases/blob/main/distributions/otelcol-contrib/Dockerfile
FROM ghcr.io/open-telemetry/opentelemetry-collector-releases/opentelemetry-collector-contrib:0.101.0 as otelcol-contrib

FROM alpine:3.19

RUN apk --no-cache --update add ca-certificates
RUN apk --no-cache add ytt --repository=https://dl-cdn.alpinelinux.org/alpine/edge/testing

COPY --from=otelcol-contrib --chmod=755 /otelcol-contrib /otelcol-contrib

COPY --chmod=755 ./entry.sh /entry.sh

COPY ./config.yaml /etc/otelcol-contrib/config.yaml

CMD sh /entry.sh

EXPOSE 4317 55678 55679
