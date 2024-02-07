FROM golang:alpine3.18 AS builder

LABEL org.opencontainers.image.source https://github.com/xianyu-one/derper

RUN apk update && \
    apk add upx && \
    go install tailscale.com/cmd/derper@main && \
    upx -9 /go/bin/derper

FROM gcr.io/distroless/base-debian12:latest

WORKDIR /app

ENV DERP_DOMAIN your-hostname.com
ENV DERP_CERT_MODE letsencrypt
ENV DERP_CERT_DIR /app/certs
ENV DERP_ADDR :443
ENV DERP_STUN true
ENV DERP_HTTP_PORT 80
ENV DERP_VERIFY_CLIENTS false

COPY --from=builder /go/bin/derper .

CMD /app/derper --hostname=$DERP_DOMAIN \
    --certmode=$DERP_CERT_MODE \
    --certdir=$DERP_CERT_DIR \
    --a=$DERP_ADDR \
    --stun=$DERP_STUN  \
    --http-port=$DERP_HTTP_PORT \
    --verify-clients=$DERP_VERIFY_CLIENTS
