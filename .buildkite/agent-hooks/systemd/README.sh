exit 0 # this is to prevent doing any stupid things when somenone decide to run this file as a script /bin/bash README.sh
# this file is just readme

# change user directory
https://stopsopa.github.io/pages/buildkite/index.html#change-user-home-directory


# WARNING: run as root
# WARNING: run as root
# WARNING: run as root
# WARNING: run as root

cd ~ # nice if it will be /home/buildkite-agent
mkdir -p root-trigger/watch
cd root-trigger

cat <<EOF > run.sh
FILE="\$1/\$2"

if [ -f "\$FILE" ]; then

  /bin/bash "\$FILE"

  rm -rf "\$FILE"
fi
EOF

# then copy here . also watch_files_in_dir.sh

cat <<EOF > /lib/systemd/system/root-trigger.service
[Unit]
Description=Root runner service

[Service]
Type=simple
WorkingDirectory=/home/buildkite-agent/root-trigger
ExecStart=/bin/bash -c "cd /home/buildkite-agent/root-trigger; /bin/bash watch_files_in_dir.sh watch run.sh | tee root-trigger.log"

[Install]
WantedBy=multi-user.target
EOF

sudo chmod 644 /lib/systemd/system/root-trigger.service
ls -la /lib/systemd/system/root-trigger.service

systemctl stop root-trigger
systemctl enable root-trigger
systemctl start root-trigger

systemctl restart root-trigger
systemctl status root-trigger


# test
# WARNING: run as buildkite-agent

cd /home/buildkite-agent/root-trigger

cat <<EOF > watch/exec.sh
echo juhu
EOF

# ------- more ----

# original file

[Unit]
Description=Buildkite Agent
Documentation=https://buildkite.com/agent
After=syslog.target
After=network.target

[Service]
Type=simple
User=buildkite-agent
Environment=HOME=/home/buildkite-agent
ExecStart=/usr/bin/buildkite-agent start
RestartSec=5
Restart=on-failure
RestartForceExitStatus=SIGPIPE
TimeoutStartSec=10
TimeoutStopSec=0
KillMode=process

[Install]
WantedBy=multi-user.target
DefaultInstance=1

