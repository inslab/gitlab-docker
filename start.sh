#!/bin/bash

# Copy gitlab.rb for the first time
if [[ ! -e /etc/gitlab/gitlab.rb ]]; then
        echo "Installing gitlab.rb config..."
        cp /opt/gitlab/etc/gitlab.rb.template /etc/gitlab/gitlab.rb
        sed -i $'s/\# postgresql\[\'shared_buffers\'\] = \"256MB\"/postgresql\[\'shared_buffers\'\] = \"10MB\"/' /etc/gitlab/gitlab.rb
        sed -i '/^external_url/s|external_url.*|external_url "http://'$DOMAIN'/gitlab" |g' /etc/gitlab/gitlab.rb
        chmod 0600 /etc/gitlab/gitlab.rb
fi

# Start service manager
echo "Starting services..."
/opt/gitlab/embedded/bin/runsvdir-start &

echo "Configuring GitLab..."
gitlab-ctl reconfigure

# Tail all logs
gitlab-ctl tail &
# Wait for SIGTERM
wait
