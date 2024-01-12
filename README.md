# plugin-kaniko

A thin shim-wrapper around the official [Google Kaniko](https://cloud.google.com/blog/products/gcp/introducing-kaniko-build-container-images-in-kubernetes-and-google-container-builder-even-without-root-access) Docker image to make it behave similar to the [Woodpecker Docker Buildx](https://woodpecker-ci.org/plugins/Docker%20Buildx) plugin.

Example `.woodpecker.yaml`:

```yaml
steps:
- name: publish
  image: woodpeckerci/plugin-kaniko
  settings:
    registry: registry.example.com # if not provided index.docker.io is used
    repo: registry.example.com/example-project
    tags: ${CI_COMMIT_SHA}
    cache: true
    skip_tls_verify: false # set to true for testing registries ONLY with self-signed certs
    build_args:
    - COMMIT_SHA=${CI_COMMIT_SHA}
    - COMMIT_AUTHOR_EMAIL=${CI_COMMIT_AUTHOR_EMAIL}
    username:
      from_secret: docker-username
    password:
      from_secret: docker-password
```

Pushing to GCR:

```yaml
steps:
- name: publish
  image: woodpeckerci/plugin-kaniko
  settings:
    registry: gcr.io
    repo: example.com/example-project
    tags: ${CI_COMMIT_SHA}
    cache: true
    json_key:
      from_secret: google-application-credentials
```

## Use `.tags` file for tagging

Similarily to [Woodpecker Docker Buildx Plugin](https://woodpecker-ci.org/plugins/Docker%20Buildx)
you can use `.tags` file to embed some custom logic for creating tags for an image.

```yaml
steps:
- name: build
  image: golang
  commands:
      - go get
      - go build
      - make versiontags > .tags
- name: publish
  image: woodpeckerci/plugin-kaniko
  settings:
    registry: registry.example.com
    repo: registry.example.com/example-project
    # tags: ${CI_COMMIT_SHA} <= it must be left undefined
    username:
      from_secret: docker-username
    password:
      from_secret: docker-password
```

## Auto tag

Set `auto_tag: true`.

```yaml
steps:
- name: build
  image: golang
  commands:
      - go get
      - go build
- name: publish
  image: woodpeckerci/plugin-kaniko
  settings:
    registry: registry.example.com
    repo: registry.example.com/example-project
    auto_tag: true # higher priority then .tags file
    # tags: ${CI_COMMIT_SHA} <= it must be left undefined to use auto_tag
    username:
      from_secret: docker-username
    password:
      from_secret: docker-password
```

## Test that it can build

```bash
docker run -it --rm -w /src -v $PWD:/src -e PLUGIN_USERNAME=${DOCKER_USERNAME} -e PLUGIN_PASSWORD=${DOCKER_PASSWORD} -e PLUGIN_REPO=woodpeckerci/plugin-kaniko-test -e PLUGIN_TAGS=test -e PLUGIN_DOCKERFILE=Dockerfile.test woodpeckerci/plugin-kaniko
```

## Test that caching works

Start a Docker registry at 127.0.0.1:5000:

```bash
docker run -d -p 5000:5000 --restart always --name registry --hostname registry.local registry:2
```

Add the following lines to plugin.sh's final command and build a new image from it:

```diff
+    --cache=true \
+    --cache-repo=127.0.0.1:5000/${PLUGIN_REPO} \
```

```bash
docker build -t woodpeckerci/plugin-kaniko .
```


Warm up the alpine image to the cache:

```bash
docker run -v $PWD:/cache gcr.io/kaniko-project/warmer:latest --verbosity=debug --image=alpine:3.8
```


Run the builder (on the host network to be able to access the registry, if any specified) with mounting the local disk cache, this example pushes to Docker Hub:

```bash
docker run --net=host -it --rm -w /src -v $PWD:/cache -v $PWD:/src -e PLUGIN_USERNAME=${DOCKER_USERNAME} -e PLUGIN_PASSWORD=${DOCKER_PASSWORD} -e PLUGIN_REPO=woodpeckerci/plugin-kaniko-test -e PLUGIN_TAGS=test -e PLUGIN_DOCKERFILE=Dockerfile.test -e PLUGIN_CACHE=true woodpeckerci/plugin-kaniko
```

The very same example just pushing to GCR instead of Docker Hub:

```bash
docker run --net=host -it --rm -w /src -v $PWD:/cache -v $PWD:/src -e PLUGIN_REGISTRY=gcr.io -e PLUGIN_REPO=paas-dev1/kaniko-test -e PLUGIN_TAGS=test -e PLUGIN_DOCKERFILE=Dockerfile.test -e PLUGIN_CACHE=true -e PLUGIN_JSON_KEY="$(<$HOME/google-application-credentials.json)" woodpeckerci/plugin-kaniko
```
