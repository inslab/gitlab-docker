#!/bin/bash

# Copy gitlab.rb for the first time
echo "Installing gitlab.rb config..."
sed -i '/^external_url/d' /opt/gitlab/etc/gitlab.rb.template
sed -i '$a external_url "http://'$DOMAIN'/gitlab"' /opt/gitlab/etc/gitlab.rb.template
cp /opt/gitlab/etc/gitlab.rb.template /etc/gitlab/gitlab.rb
chmod 0600 /etc/gitlab/gitlab.rb

# Start service manager
echo "Starting services..."
/opt/gitlab/embedded/bin/runsvdir-start &

echo "Configuring GitLab..."
gitlab-ctl reconfigure

# Tail all logs
gitlab-ctl tail &
# Wait for SIGTERM
wait
