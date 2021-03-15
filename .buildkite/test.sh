
set -x          # Expand and print each command before executing
set -e          # Exit script immediately if any command returns a non-zero exit status.
set -o pipefail # more: https://buildkite.com/docs/pipelines/writing-build-scripts#configuring-bash

echo "+++ run cypress in docker"

/bin/bash test.sh .env.gh docker -- /bin/bash test.sh .env.gh

