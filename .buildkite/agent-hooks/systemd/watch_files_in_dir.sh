#!/bin/bash

# run.sh example
#FILE="$1/$2"
#
#if [ -f "$FILE" ]; then
#
#  /bin/bash "$FILE"
#
#  rm -rf "$FILE"
#fi

# systemd deamon example
#cat <<EOF > /lib/systemd/system/root-trigger.service
#[Unit]
#Description=Root runner service
#
#[Service]
#Type=simple
#ExecStart=/bin/bash /var/lib/buildkite-agent/builds/machine-buildkite/ses/root-trigger/watch_files_in_dir.sh . run.sh
#
#[Install]
#WantedBy=multi-user.target
#EOF
#
#sudo chmod 644 /lib/systemd/system/root-trigger.service
#ls -la /lib/systemd/system/root-trigger.service
#sudo systemctl start root-trigger
#sudo systemctl enable root-trigger
#sudo systemctl status root-trigger



HELP="$(inotifywait --help 2>&1)"

REG="Wait for a particular event"

if ! [[ $HELP =~ $REG ]]; then

  echo "inotifywait tool is not available, visit: https://github.com/inotify-tools/inotify-tools/wiki";

  exit 1;
fi

if [ ! -d "$1" ]; then

  echo "first argument '$1' is not a directory";

  exit 1;
fi

DIR="$1";

shift;

if [ ! -f "$1" ]; then

  echo "second argument '$1' is not a bash script";

  exit 1;
fi

SCRIPT="$1";

shift;

REG="ISDIR"

inotifywait -mr -e delete -e attrib -e modify "$DIR" | while read -r dir action file; do

  if ! [[ $action =~ $REG ]]; then

    TIME="$(date +"%Y-%m-%d %H:%M:%S")";

    /bin/bash "$SCRIPT" "$(realpath "$dir")" "$file" "$action";

    echo "=== $0 $TIME $action $file exit code: $?";
  fi
done

