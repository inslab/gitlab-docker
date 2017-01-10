FROM ubuntu:14.04
MAINTAINER Minchul Ahn <minchulahn@inslab.co.kr>

# Install required packages
RUN apt-get update -q \
    && DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
      curl \
      ca-certificates \
      openssh-server \
      wget \
      apt-transport-https \
      vim \
      nano

# Download & Install GitLab
RUN curl -LJO https://packages.gitlab.com/gitlab/gitlab-ce/packages/ubuntu/trusty/gitlab-ce_8.15.3-ce.0_amd64.deb/download
RUN dpkg -i gitlab-ce_8.15.3-ce.0_amd64.deb

ADD start.sh /opt/gitlab/start.sh
RUN chmod 777 /opt/gitlab/start.sh

# Define data volumes
VOLUME ["/etc/gitlab", "/var/opt/gitlab", "/var/log/gitlab"]

# Expose web & ssh
EXPOSE 443 80 22

# Setup the Docker container environment and run Gitlab
WORKDIR /opt/gitlab
CMD ["/opt/gitlab/start.sh"]
