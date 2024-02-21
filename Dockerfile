FROM jenkins/ssh-agent:debian-jdk11

LABEL maintainer="Jan Zarzycki <jzarzycki97@gmail.com>"
ARG TZ=Europe/Warsaw

# Make sure the package repository is up to date and intall dependencies
RUN apt-get update && \
    apt-get -y full-upgrade && \
    apt-get install -y software-properties-common gnupg git python3-launchpadlib curl wget gettext-base

# Add tool's repositories
RUN apt-add-repository -y ppa:ansible/ansible && \
    wget -O- https://apt.releases.hashicorp.com/gpg | \
    gpg --dearmor | \
    tee /usr/share/keyrings/hashicorp-archive-keyring.gpg && \
    gpg --no-default-keyring \
    --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg \
    --fingerprint && \
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
    https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
    tee /etc/apt/sources.list.d/hashicorp.list

# Install tools and cleanup old packages
RUN apt -y update && apt-get install -y terraform ansible ansible-lint && \
    apt-get -y autoremove


# Set up the working environment
RUN mkdir -p /home/jenkins/.terraform.d && chown jenkins:jenkins /home/jenkins/.terraform.d
