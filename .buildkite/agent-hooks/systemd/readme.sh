
# WARNING: run as buildkite-agent
# WARNING: run as buildkite-agent
# WARNING: run as buildkite-agent
# WARNING: run as buildkite-agent

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

# WARNING: run as root
# WARNING: run as root
# WARNING: run as root
# WARNING: run as root
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
sudo systemctl restart root-trigger
sudo systemctl enable root-trigger
sudo systemctl status root-trigger


# test
# WARNING: run as buildkite-agent

cd /home/buildkite-agent/root-trigger

cat <<EOF > watch/exec.sh
echo juhu
EOF

