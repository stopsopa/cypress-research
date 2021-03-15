
THEN_REMOVE_OLDER_THAN_X_DAYS=30;

RESPAWN_ENV_MAIN_DIR="$(pwd)/.git/.respawn"

function init {

  rm -rf "$1/*"

  /bin/bash gitstorage.sh pull --force

  /bin/bash gitstorage.sh backup "$1"
}

function respawn {

  /bin/bash gitstorage.sh restore "$1"
}

RESPAWN_ENV="$(buildkite-agent meta-data get "RESPAWN_ENV" 2> /dev/null || true)"

if [ "$RESPAWN_ENV" != "" ]; then

  FINALDIR="$RESPAWN_ENV_MAIN_DIR/$RESPAWN_ENV"
fi

if [ "$FINALDIR" = "" ] || [ ! -d "$FINALDIR" ]; then

  _BUILDKITE_BRANCH="$(echo "$BUILDKITE_BRANCH" | sed -E "s/\//--/")"

  RESPAWN_ENV="$(date +"%Y-%m-%d_%H-%M-%S")-$_BUILDKITE_BRANCH-${BUILDKITE_COMMIT:0:7}"

  if [ "$BUILDKITE_PULL_REQUEST" != "" ]; then

    RESPAWN_ENV="$RESPAWN_ENV-$BUILDKITE_PULL_REQUEST"
  fi

  if [ "$BUILDKITE_PULL_REQUEST_BASE_BRANCH" != "" ]; then

    RESPAWN_ENV="$RESPAWN_ENV-$BUILDKITE_PULL_REQUEST_BASE_BRANCH"
  fi



  buildkite-agent meta-data set "RESPAWN_ENV" "$RESPAWN_ENV"

  FINALDIR="$RESPAWN_ENV_MAIN_DIR/$RESPAWN_ENV"

  mkdir -p "$FINALDIR"

  { green "init    : RESPAWN_ENV=$RESPAWN_ENV"; } 2>&3

  init "$FINALDIR"
else

  { green "respawn : RESPAWN_ENV=$RESPAWN_ENV"; } 2>&3

  respawn "$FINALDIR"
fi

find "$RESPAWN_ENV_MAIN_DIR" -maxdepth 1 -type d -mtime +$THEN_REMOVE_OLDER_THAN_X_DAYS -exec rm -rf {} \;