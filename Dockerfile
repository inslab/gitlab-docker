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
RUN curl -sS https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.deb.sh | sudo bash
RUN apt-get install gitlab-ce
RUN cd /etc/gitlab/ && \
    sed -i '/^external_url/s|external_url |#external_url |g' gitlab.rb && \
    sed -i '$a host = `hostname`.strip\nexternal_url "http://#{host}/gitlab"' gitlab.rb
RUN mkdir -p /var/opt/gitlab
RUN cp /etc/gitlab/gitlab.rb /var/opt/gitlab/gitlab.rb

ADD start.sh /var/opt/gitlab/start.sh
RUN chmod 777 /var/opt/gitlab/start.sh

# Define data volumes
VOLUME ["/etc/gitlab", "/var/opt/gitlab", "/var/log/gitlab"]

# Expose web & ssh
EXPOSE 443 80 22

# Setup the Docker container environment and run Gitlab
WORKDIR /var/opt/gitlab
CMD ["/var/opt/gitlab/start.sh"]

