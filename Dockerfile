# syntax=docker/dockerfile:1.4
FROM alpine:3.16
LABEL org.opencontainers.image.source="https://github.com/patrick246/keycloak-foundryvtt-theme"
LABEL org.opencontainers.image.licenses="MIT"
LABEL org.opencontainers.image.title="Keycloak FoundryVTT Login Theme"
LABEL org.opencontainers.image.description="A Keycloak login theme in the style of FoundryVTTs interface."
LABEL org.opencontainers.image.authors="patrick246"
COPY --link /foundryvtt-theme /foundryvtt-theme

