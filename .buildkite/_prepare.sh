
echo "------"
echo "HOME=$HOME"
echo "------"

if [ "$HOME" != "/home/buildkite-agent" ]; then

  echo "HOME is not equal /home/buildkite-agent";

  exit 1
fi

source ~/.bashrc

echo "ROOT=$ROOT"

cd "$ROOT";

ENVFILE="$1"

if [ ! -f "${ENVFILE}" ]; then

    echo "${ENVFILE} does not exist."

    exit 1;
fi

source "$ENVFILE"

ENVFILEBASENAME="$(basename "$ENVFILE")"

#if [ "$PROJECT_NAME" = "" ]; then
#
#  echo "PROJECT_NAME is not defined";
#
#  exit 1
#fi
#
#if [ "$PROTECTED_KUB_CLUSTER" = "" ]; then
#
#  echo "PROTECTED_KUB_CLUSTER is not defined";
#
#  exit 1
#fi
#
#if [ "$PROTECTED_DOCKER_REGISTRY" = "" ]; then
#
#  echo "PROTECTED_DOCKER_REGISTRY is not defined";
#
#  exit 1
#fi

set -x          # Expand and print each command before executing
set -e          # Exit script immediately if any command returns a non-zero exit status.
set -o pipefail # more: https://buildkite.com/docs/pipelines/writing-build-scripts#configuring-bash