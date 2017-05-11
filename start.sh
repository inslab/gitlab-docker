#!/bin/bash

CONFIG_FILE=/etc/gitlab/gitlab.rb
cat > /tmp/ldap_settings <<EOF
gitlab_rails['ldap_enabled'] = true
gitlab_rails['ldap_servers'] = YAML.load <<-'EOS'
  main:
    host: '${LDAP_HOST}'
    port: ${LDAP_PORT}
    uid: 'uid'
    method: 'plain'
    active_directory: false
    base: '${LDAP_BASE_DN}'
    bind_dn: ''
    password: ''
EOS
EOF

# Copy gitlab.rb for the first time
if [[ ! -e $CONFIG_FILE ]]; then
    echo "Installing gitlab.rb config..."
    cp /opt/gitlab/etc/gitlab.rb.template $CONFIG_FILE
    sed -i $'s/\# postgresql\[\'shared_buffers\'\] = \"256MB\"/postgresql\[\'shared_buffers\'\] = \"10MB\"/' $CONFIG_FILE
    sed -i '/^external_url/s|external_url.*|external_url "http://'$DOMAIN'/gitlab" |g' $CONFIG_FILE
    cat /tmp/ldap_settings >> $CONFIG_FILE
    chmod 0600 $CONFIG_FILE
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
