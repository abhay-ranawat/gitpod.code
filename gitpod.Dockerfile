FROM gitpod/workspace-full

USER root

RUN curl -fsSL https://tailscale.com/install.sh | sh
     
RUN update-alternatives --set ip6tables /usr/sbin/ip6tables-nft
