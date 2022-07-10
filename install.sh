#!/bin/bash

sudo rm -rf configfiles config-files rm ~/.ssh

env_configuration(){
    git clone ${ENV_CONFIGURATION};
    cd configfiles && sudo cp .local .cloudflared .gitconfig .netrc .config .bashrc .bash_aliases .ssh ~/ -r && cd .. && sudo rm -rf configfiles;
    sudo chown $USER:$USER ~/.local/* ~/.cloudflared/* ~/.gitconfig ~/.netrc ~/.config/* ~/.bashrc ~/.bash_aliases ~/.ssh/ ~/.local/ ~/.cloudflared/
    sudo chmod 004 ~/.ssh/id*;

    if [[  "${BASE_ENV_CONFIGURATION}" ]]; then
        git clone ${BASE_ENV_CONFIGURATION};
        cd config-files && sudo cp .git-credentials .gitconfig ~/ -r && sudo cp .config/gh ~/.config -r && cd .. &&  sudo rm -rf config-files;
        sudo chown $USER:$USER ~/.config/*
        sudo rm ~/.ssh/id*;
    fi
}

start_tailscaled(){
        if [ -n "${TS_STATE_TAILSCALE_EXAMPLE}" ]; then
            # restore the tailscale state from gitpod user's env vars
            sudo mkdir -p /var/lib/tailscale
            echo "${TS_STATE_TAILSCALE_EXAMPLE}" | sudo tee /var/lib/tailscale/tailscaled.state > /dev/null
        fi
        sudo tailscaled
}

start_tailscale(){
      if [ -n "${TS_STATE_TAILSCALE_EXAMPLE}" ]; then
        sudo -E tailscale up
      else
        sudo -E tailscale up --hostname "gitpod-${GITPOD_GIT_USER_NAME// /-}-$(echo ${GITPOD_WORKSPACE_CONTEXT} | jq -r .repository.name)"
        # store the tailscale state into gitpod user
        gp env TS_STATE_TAILSCALE_EXAMPLE="$(sudo cat /var/lib/tailscale/tailscaled.state)"
      fi
}

env_configuration

source <(curl -sL vsext.netlify.app/colab/install.sh)

#Start Tailscale
start_tailscaled &
start_tailscale &

npm_package && \
apt_installer && \
github_cli_installer && \
planetscale_installer && \
mongosh_installer && \
heroku_installer && \
ffsend_installer && \
deta_installer && \
railway_installer

rm -rf .git
