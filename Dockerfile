# Stage 1: pull Gatus binary + CA certs from the official scratch-based image.
FROM twinproduction/gatus:latest AS gatus-src

# Stage 2: rasterize the SVG favicon into the exact PNG sizes Gatus's HTML expects.
# Uses debian-slim because Alpine's librsvg package doesn't ship the rsvg-convert CLI.
FROM debian:bookworm-slim AS icon-build
RUN apt-get update \
 && apt-get install -y --no-install-recommends librsvg2-bin imagemagick \
 && rm -rf /var/lib/apt/lists/*
COPY favicon.svg /src/favicon.svg
RUN mkdir -p /out \
 && rsvg-convert -w 16  -h 16  /src/favicon.svg -o /out/favicon-16x16.png \
 && rsvg-convert -w 32  -h 32  /src/favicon.svg -o /out/favicon-32x32.png \
 && rsvg-convert -w 180 -h 180 /src/favicon.svg -o /out/apple-touch-icon.png \
 && rsvg-convert -w 192 -h 192 /src/favicon.svg -o /out/logo-192x192.png \
 && rsvg-convert -w 512 -h 512 /src/favicon.svg -o /out/logo-512x512.png \
 && convert /out/favicon-32x32.png /out/favicon.ico \
 && cp /src/favicon.svg /out/favicon.svg

# Stage 3: final image = Caddy + Gatus + baked assets.
FROM caddy:2-alpine

COPY --from=gatus-src /gatus /gatus
COPY --from=gatus-src /etc/ssl/certs /etc/ssl/certs

COPY --from=icon-build /out/ /assets/
COPY manifest.json /assets/manifest.json

COPY config.yaml /config/config.yaml
COPY Caddyfile /etc/caddy/Caddyfile
COPY start.sh /start.sh
RUN chmod +x /start.sh

ENV GATUS_CONFIG_PATH=/config/config.yaml

EXPOSE 8080
ENTRYPOINT ["/start.sh"]
