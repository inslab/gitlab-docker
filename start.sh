#!/bin/bash

/opt/gitlab/embedded/bin/runsvdir-start & 
gitlab-ctl reconfigure

# Tail all logs
gitlab-ctl tail &
# Wait for SIGTERM
wait
