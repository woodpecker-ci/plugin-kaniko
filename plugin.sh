#!/busybox/busybox sh
# shellcheck disable=SC2187

set -euo pipefail

concatenate_strings() {
    _STR1="${1}"
    _STR2="${2}"

    if [ -n "${_STR1}" ]; then
        _STR1="${_STR1} ${_STR2}"
    else
        _STR1="${_STR2}"
    fi

    echo "${_STR1}"
}

export PATH="$PATH:/kaniko/"

REGISTRY=${PLUGIN_REGISTRY:-https://index.docker.io/v1/}

if [ -f "${PWD}/${PLUGIN_ENV_FILE:-}" ]; then
    # shellcheck disable=SC3001
    while IFS= read -r line; do
        export "${line?}"
    done < <(grep -v '^ *#' < "${PWD}/${PLUGIN_ENV_FILE}")
fi

if [ "${PLUGIN_USERNAME:-}" ] || [ "${PLUGIN_PASSWORD:-}" ]; then
    DOCKER_AUTH=$(echo -n "${PLUGIN_USERNAME}:${PLUGIN_PASSWORD}" | base64 | tr -d "\n")

    cat > /kaniko/.docker/config.json <<DOCKERJSON
{
    "auths": {
        "${REGISTRY}": {
            "auth": "${DOCKER_AUTH}"
        }
    }
}
DOCKERJSON
fi

if [ "${PLUGIN_JSON_KEY:-}" ];then
    echo "${PLUGIN_JSON_KEY}" > /kaniko/gcr.json
    export GOOGLE_APPLICATION_CREDENTIALS=/kaniko/gcr.json
fi

DOCKERFILE=${PLUGIN_DOCKERFILE:-Dockerfile}
CONTEXT=${PLUGIN_CONTEXT:-$PWD}
LOG=${PLUGIN_LOG_LEVEL:-info}
EXTRA_OPTS=""

if [ -n "${PLUGIN_TARGET:-}" ]; then
    TARGET="--target=${PLUGIN_TARGET}"
fi

if [ "${PLUGIN_SKIP_TLS_VERIFY:-}" = "true" ]; then
    EXTRA_OPTS=$(concatenate_strings "${EXTRA_OPTS}" '--skip-tls-verify=true')
fi

if [ "${PLUGIN_CACHE:-}" = "true" ]; then
    CACHE="--cache=true"
fi

if [ -n "${PLUGIN_CACHE_REPO:-}" ]; then
    CACHE_REPO="--cache-repo=${REGISTRY}/${PLUGIN_CACHE_REPO}"
fi

if [ -n "${PLUGIN_CACHE_TTL:-}" ]; then
    CACHE_TTL="--cache-ttl=${PLUGIN_CACHE_TTL}"
fi

if [ -n "${PLUGIN_BUILD_ARGS:-}" ]; then
    BUILD_ARGS=$(echo "${PLUGIN_BUILD_ARGS}" | tr ',' '\n' | while read -r build_arg; do echo "--build-arg \"${build_arg}\""; done)
fi

BUILD_ARGS_FROM_ENV=""
if [ -n "${PLUGIN_BUILD_ARGS_FROM_ENV:-}" ]; then
    # shellcheck disable=SC3001
    while IFS= read -r build_arg; do
        BUILD_ARGS_FROM_ENV=$(concatenate_strings "${BUILD_ARGS_FROM_ENV}" "--build-arg ${build_arg}=$(eval "echo \$$build_arg")")
    done < <(echo "${PLUGIN_BUILD_ARGS_FROM_ENV}" | tr ',' '\n')
fi

# auto_tag, if set auto_tag: true, auto generate .tags file
# support format Major.Minor.Release or start with `v`
# docker tags: Major, Major.Minor, Major.Minor.Release and latest
if [ "${PLUGIN_AUTO_TAG:-}" = "true" ]; then
    TAG=$(echo "${CI_COMMIT_TAG:-}" |sed 's/^v//g')
    part=$(echo "${TAG}" |tr '.' '\n' |wc -l)
    # expect number
    # shellcheck disable=SC3020
    echo "${TAG}" |grep -E "[a-z-]" &>/dev/null && isNum=1 || isNum=0

    if [ -z "${TAG:-}" ]; then
        echo "latest" > .tags
    elif [ "${isNum}" -eq 1 ] || [ "${part}" -gt 3 ]; then
        echo "${TAG},latest" > .tags
    else
        major=$(echo "${TAG}" |awk -F'.' '{print $1}')
        minor=$(echo "${TAG}" |awk -F'.' '{print $2}')
        release=$(echo "${TAG}" |awk -F'.' '{print $3}')

        major=${major:-0}
        minor=${minor:-0}
        release=${release:-0}

        echo "${major},${major}.${minor},${major}.${minor}.${release},latest" > .tags
    fi
fi

if [ -n "${PLUGIN_MIRRORS:-}" ]; then
    MIRROR="$(echo "${PLUGIN_MIRRORS}" | tr ',' '\n' | while read -r mirror; do echo "--registry-mirror=${mirror}"; done)"
fi

DESTINATIONS=""
if [ "${PLUGIN_DRY_RUN:-}" = "true" ] || [ -z "${PLUGIN_REPO:-}" ]; then
    DESTINATIONS="--no-push"
    # Cache is not valid with --no-push
    CACHE=""
elif [ -n "${PLUGIN_TAGS:-}" ]; then
    DESTINATIONS=$(echo "${PLUGIN_TAGS}" | tr ',' '\n' | while read -r tag; do echo "--destination=${REGISTRY}/${PLUGIN_REPO}:${tag} "; done)
elif [ -f .tags ]; then
    # shellcheck disable=SC3001
    while IFS= read -r tag; do
        DESTINATIONS=$(concatenate_strings "${DESTINATIONS}" "--destination=${REGISTRY}/${PLUGIN_REPO}:${tag}")
    done < <(sed -e 's/,\s*/\n/g' .tags)
elif [ -n "${PLUGIN_REPO:-}" ]; then
    DESTINATIONS="--destination=${REGISTRY}/${PLUGIN_REPO}:latest"
fi

if [ "${PLUGIN_IGNORE_VAR_RUN:-}" = "false" ]; then
    EXTRA_OPTS=$(concatenate_strings "${EXTRA_OPTS}" "--ignore-var-run=false")
fi

# Double quotes can't be used, otherwise kaniko takes all arguments as one.
# With bash, an array could have been used to avoid disabling this check.
# shellcheck disable=SC2086
/kaniko/executor -v "${LOG}" \
    --context="${CONTEXT}" \
    --dockerfile="${DOCKERFILE}" \
    ${EXTRA_OPTS} \
    ${DESTINATIONS} \
    "${CACHE:-}" \
    "${CACHE_TTL:-}" \
    "${CACHE_REPO:-}" \
    "${TARGET:-}" \
    ${BUILD_ARGS:-} \
    ${BUILD_ARGS_FROM_ENV:-} \
    "${MIRROR:-}"
