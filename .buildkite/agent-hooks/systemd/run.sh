
FILE="$1/$2"

if [ -f "$FILE" ]; then

  /bin/bash "$FILE"

  rm -rf "$FILE"
fi
