---
name: Kaniko
author: Woodpecker Authors
description: Plugin to build container images without root privileges
tags: [docker, podman, container, build]
containerImage: woodpeckerci/plugin-kaniko
containerImageUrl: https://hub.docker.com/r/woodpeckerci/plugin-kaniko
url: https://github.com/woodpecker-ci/plugin-kaniko
---

Settings can be defined using the `settings` option for woodpecker plugins. All available settings and their defaults are listed below.

## Settings

| Settings Name | Default                       | Description                                        |
| ------------- | ----------------------------- | -------------------------------------------------- |
| `dry-run`     | `false`                       | disables docker push                               |
| `repo`        | _none_                        | sets repository name for the image (can be a list) |
| `username`    | _none_                        | sets username to authenticates with                |
| `password`    | _none_                        | sets password / token to authenticates with        |
| `registry`    | `https://index.docker.io/v1/` | sets docker registry to authenticate with          |
| `dockerfile`  | `Dockerfile`                  | sets dockerfile to use for the image build         |
| `tags`        | _none_                        | sets repository tags to use for the image          |

## Advanced Settings

| Settings Name         | Default | Description                                                                                                                                      |
| --------------------- | ------- | ------------------------------------------------------------------------------------------------------------------------------------------------ |
| `context`             | `.`     | sets the path of the build context to use                                                                                                        |
| `build-args`          | _none_  | sets custom build arguments for the build                                                                                                        |
| `build-args-from-env` | _none_  | forwards environment variables as custom arguments to the build                                                                                  |
| `auto-tag`            | `false` | if set generate .tags file, support format Major.Minor.Release or start with `v` docker tags: Major, Major.Minor, Major.Minor.Release and latest |
| `log-level`           | `info`  | set different log level                                                                                                                          |
| `target`              | _none_  | indicate which build stage is the target build stage                                                                                             |
| `cache`               | `false` | use a cache repo                                                                                                                                 |
| `cache-repo`          | _none_  | specify the cache repo                                                                                                                           |
| `cache-ttl`           | _none_  | set the time to live for the cache                                                                                                               |
| `skip-tls-verify`     | `false` | ignore tls issues                                                                                                                                |
| `mirrors`             | _none_  | set docker hub mirrors                                                                                                                           |
| `json-key`            | _none_  | pass a json key to kaniko                                                                                                                        |
| `insecure`            | `false` | push images to a plain HTTP registry.                                                                                                            |
| `insecure-pull`       | `false` | pull images from a plain HTTP registry.                                                                                                          |
| `insecure-registry`   | _none_  | use plain HTTP requests when accessing the specified registry.                                                                                   |
