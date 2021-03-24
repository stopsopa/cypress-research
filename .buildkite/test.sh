
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd -P )"

ROOT="$DIR/.."

source "$ROOT/.buildkite/_prepare.sh" "$ROOT/.env.gh"

if [ "$CYPRESS_BASE_URL" = "" ]; then

  echo "CYPRESS_BASE_URL is not defined"

  exit 1
fi

#TEST_DOMAIN="$(buildkite-agent meta-data get "TEST_DOMAIN")"
#
#if [ "$TEST_DOMAIN" = "" ]; then
#
#  echo "TEST_DOMAIN is not defined"
#
#  exit 1
#fi
#
#printf "\nCYPRESS_BASE_URL=\"https://$(echo $TEST_DOMAIN)\"\n" >> "$ENVFILE"

function cleanup {
  (
    cd /home/buildkite-agent/root-trigger

cat <<EOF > "watch/$PROJECT_NAME.sh"
chmod -R a+w "$ROOT"
EOF

    sleep 1

    date +"%Y-%m-%d %H:%M:%S"

    cat root-trigger.log | tail -n 10
  )
}

trap cleanup EXIT

/bin/bash cypress.sh "$ENVFILEBASENAME" docker -- /bin/bash cypress.sh "$ENVFILEBASENAME" -- cypress run -C cypress-docker.json


