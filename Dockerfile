FROM debian:bookworm

# Optimization. See: https://blog.packagecloud.io/eng/2017/02/21/set-environment-variable-save-thousands-of-system-calls/
ENV TZ     :/etc/localtime
SHELL ["/bin/bash", "-c"]

ARG MPRIME_BUILD=p95v3019b20

# we create a user/group for mprime, but we will run from a different directory
RUN DEBIAN_FRONTEND=noninteractive && apt-get update && apt-get upgrade -y && apt-get -y install --no-install-recommends \
    ca-certificates \
    tmux \
    wget \
    && apt-get clean && rm /var/lib/apt/lists/*.* \
    && groupadd --gid 1000 mprime \
    && useradd --home-dir /opt/mprime --shell /bin/sh --uid 1000 --gid 1000 mprime \
    && mkdir -p /opt/mprime /mnt/mprime \
    && s=b* \
    && wget -qO- https://download.mersenne.ca/mirror/gimps/${MPRIME_BUILD:3:3}/${MPRIME_BUILD:4:2}.${MPRIME_BUILD:6:${#MPRIME_BUILD}-7-${#s}}/${MPRIME_BUILD}.linux64.tar.gz | tar xz -C /opt/mprime/ \
    && chown -R mprime:mprime /mnt/mprime

USER mprime
WORKDIR /opt/mprime

