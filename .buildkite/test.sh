
echo "------"
echo "HOME=$HOME"
echo "------"

export HOME="/home/buildkite-agent"

source ~/.bashrc

echo "------"
echo "HOME=$HOME"
echo "------"
if [ "$HOME" != "/home/buildkite-agent" ]; then

  echo "HOME is not equal /home/buildkite-agent";

  exit 1
fi

echo "ROOT=$ROOT"

cd "$ROOT";

set -x          # Expand and print each command before executing
set -e          # Exit script immediately if any command returns a non-zero exit status.
set -o pipefail # more: https://buildkite.com/docs/pipelines/writing-build-scripts#configuring-bash

echo "+++ run cypress in docker"

/bin/bash cypress.sh .env.gh docker -- /bin/bash cypress.sh .env.gh -- cypress run -C cypress-docker.json

