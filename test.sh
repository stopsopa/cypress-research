
if [ ! -f "cypress.json" ]; then

  echo "You should run this command from directory with cypress.json file in it"

  exit 1
fi

if [ "$1" = "" ]; then

  echo "Specify location to env file as a first argument"

  echo "present env files are:"

  ls .env*

  exit 1
fi

if [ ! -f "$1" ]; then

  echo "'$1' is not a file"

  exit 1
fi

set -e
#set -x

eval "$(/bin/bash bash/exportsource.sh "$1")"

# https://docs.cypress.io/guides/guides/environment-variables.html

#echo "$CYPRESS_BASE_URL"

node_modules/.bin/cypress open