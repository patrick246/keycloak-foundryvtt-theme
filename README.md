# keycloak-foundryvtt-theme
A [Keycloak](https://www.keycloak.org/) login theme in the style of FoundryVTTs interface. Developed for Keycloak 18, no guarantees for older Keycloak versions.

## Installation
This theme can be installed in various ways.

### Manual Download & Move
If you're running a Keycloak manually installed on a machine, then the easiest way to install this theme is by downloading a release and moving the `foundryvtt-theme` folder in your Keycloak installation's `theme` folder.

### Docker: Multi-Stage-Build
If you're building your own Keycloak base image (as you probably should, starting with Keycloak 17, to profit from the improved startup times), then you can use the provided image `ghcr.io/patrick246/keycloak-foundryvtt-theme:${some released version}` from the release section as a multi-stage-build base image.

```Dockerfile
ARG FOUNDRYVTT_THEME_RELEASE
FROM ghcr.io/patrick246/keycloak-foundryvtt-theme:$FOUNDRYVTT_THEME_RELEASE as theme

ARG KEYCLOAK_RELEASE
FROM quay.io/keycloak/keycloak:$KEYCLOAK_RELEASE as builder
COPY --from=theme /foundryvtt-theme/ /opt/keycloak/themes/foundryvtt-theme/
# Set your required build time envs here
# ENV KC_DB=?
# ENV KC_HEALTH_ENABLED=true
# ...
RUN /opt/keycloak/bin/kc.sh build

ARG KEYCLOAK_RELEASE
FROM quay.io/keycloak/keycloak:$KEYCLOAK_RELEASE
COPY --from=builder /opt/keycloak/ /opt/keycloak/
WORKDIR /opt/keycloak
ENTRYPOINT ["/opt/keycloak/bin/kc.sh", "start"]
```

### Docker: Bind mount
If you're not building your own Keycloak Docker image, then you can still make use of this theme. Download the theme like in the Manual Download & Move section, place it somewhere on the Docker host that you're running Keycloak on, and bind-mount the `foundryvtt-theme` folder to `/opt/keycloak/themes/foundryvtt-theme`. This repository has a docker-compose.yaml that uses this installation method for theme development purposes.

### Kubernetes: Init-Container
When running Keycloak in Kubernetes, you can run the provided Docker image as an init container, copy the theme contents into an `emptyDir` volume, and mount this volume in the Keycloak container at `/opt/keycloak/themes/foundryvtt-theme`.

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: keycloak
spec:
  selector:
    matchLabels:
      app: keycloak
  template:
    metadata:
      labels:
        app: keycloak
    spec:
      initContainers:
        - name: foundryvtt-theme
          image: ghcr.io/patrick246/keycloak-foundryvtt-theme:1.2.3
          command:
            - sh
            - -c
            - |
              cp -r /foundryvtt-theme/* /themes/foundryvtt-theme/
          volumeMounts:
            - mountPath: /themes/foundryvtt-theme
              name: theme
      containers:
        - name: keycloak
          image: quay.io/keycloak/keycloak:18.0.2
          volumeMounts:
            - mountPath: /opt/keycloak/themes/foundryvtt-theme
              name: theme
          # All the other things, env vars, resources, readiness probes, ports,  ...
      volumes:
        - name: theme
          emptyDir: {}
```

## Build it yourself
In case you want to build the Docker image yourself, you can do this by running the following command:

```bash
docker buildx build -t your-registry.example.com/your-user/keycloak-foundryvtt-theme:v0.0.1 .
```

## Dependencies
This theme uses [Bootstrap 5.2's](https://github.com/twbs/bootstrap/tree/v5.2.0-beta1) reboot and grid css files. The two minified files were merged and placed in `foundryvtt-theme/resources/css/bootstrap/bootstrap-reboot-grid.min.css`.

No installation of dependencies is necessary.