
if [ ! -f "cypress.json" ]; then

  echo "You should run this command from directory with cypress.json file in it"

  exit 1
fi

if [ "$1" = "" ]; then

  echo "Specify location to env file as a first argument"

  echo "present env files are:"

  ls .env*



cat << EOF

More help:

# local dev
/bin/bash test.sh .env.gh

# CI/CD environment
/bin/bash test.sh .env.gh docker -- /bin/bash test.sh .env.gh
  # run tests using test.sh inside container - to properly read given .env file inside

just provide .env file with CYPRESS_BASE_URL like:
  CYPRESS_BASE_URL=https://stopsopa.github.io/cypress-research

# other useful
/bin/bash $0 .env.gh docker -- /bin/bash
/bin/bash $0 .env.gh docker -- ls -la

EOF

  exit 1
fi

if [ ! -f "$1" ]; then

  echo "'$1' is not a file"

  exit 1
fi

_ENVFILE="$1"

shift;

_DOCKER="0"

if [ "$1" = "docker" ]; then

  shift;

  _DOCKER="1"
fi








PARAMS=""
REST=""
_EVAL=""
while (( "$#" )); do
  case "$1" in
    --) # end argument parsing
      shift;
#      while (( "$#" )); do          # optional
#        if [ "$1" = "&&" ]; then
#          REST="$REST \&\&"
#        else
#          if [ "$REST" = "" ]; then
#            REST="\"$1\""
#          else
#            REST="$REST \"$1\""
#          fi
#        fi
#        shift;                      # optional
#      done                          # optional if you need to pass: /bin/bash $0 -f -c -- -f "multi string arg"
      break;
      ;;
    -*|--*=) # unsupported flags
      echo "$0 Error: Unsupported flag $1" >&2
      exit 1;
      ;;
    *) # preserve positional arguments
      if [ "$1" = "&&" ]; then
          PARAMS="$PARAMS \&\&"
      else
        if [ "$PARAMS" = "" ]; then
            PARAMS="\"$1\""
        else
          PARAMS="$PARAMS \"$1\""
        fi
      fi
      shift;
      ;;
  esac
done

trim() {
    local var="$*"
    # remove leading whitespace characters
    var="${var#"${var%%[![:space:]]*}"}"
    # remove trailing whitespace characters
    var="${var%"${var##*[![:space:]]}"}"
    echo -n "$var"
}

PARAMS="$(trim "$PARAMS")"

FINAL="$@"
if [ "$FINAL" = "" ]; then

  FINAL="cypress run"
fi

#eval set -- "$PARAMS"

#echo "\$PARAMS=$PARAMS"
#
#echo "\$REST=$REST"
#
#echo "\$@=$@"
#
#echo "\$FINAL=$FINAL"
#
##
#exit 0
##
##

#function cleanup {
#
#    echo "cleanup"
#
#    chmod -R a+w cypress
#}
#
#trap cleanup EXIT


set -e
#set -x

if [ "$_DOCKER" = "1" ]; then

  echo -e "\n    docker run -it -v \"$(pwd):/e2e\" -w /e2e --env __DOCKER=true --entrypoint=\"\" cypress/included:6.6.0 $FINAL\n"

                 docker run -it -v "$(pwd):/e2e"   -w /e2e --env __DOCKER=true --entrypoint=""   cypress/included:6.6.0 $FINAL

#  echo -e "\n    docker run -it -v \"$(pwd):/e2e\" -w /e2e --env-file \"$_ENVFILE\" --entrypoint=\"\" cypress/included:6.6.0 $FINAL\n"
#
#                 docker run -it -v "$(pwd):/e2e"   -w /e2e --env-file "$_ENVFILE"   --entrypoint=""   cypress/included:6.6.0 $FINAL
else

  eval "$(/bin/bash bash/exportsource.sh "$_ENVFILE")"

  # https://docs.cypress.io/guides/guides/environment-variables.html

  #echo "$CYPRESS_BASE_URL"

  if [ "$__DOCKER" = "true" ]; then

    cypress run
  else

    node_modules/.bin/cypress open
  fi

fi