#!/bin/bash

sudo rm -rf configfiles config-files rm ~/.ssh

env_configuration(){
    git clone ${ENV_CONFIGURATION} && \
    sudo chown -R $USER:$(id -gn) configfiles && \
    cd configfiles && sudo cp .local .cloudflared .gitconfig .netrc .config .bashrc .bash_aliases .ssh ~/ -r && cd .. && sudo rm -rf configfiles && \
    sudo chmod 004 ~/.ssh/id*;

    if [[  "${BASE_ENV_CONFIGURATION}" ]]; then
        git clone ${BASE_ENV_CONFIGURATION} && \
        sudo chown -R $USER:$(id -gn) config-files && \
        cd config-files && sudo cp .deta .git-credentials .gitconfig ~/ -r && sudo cp .local/share/com.vercel.cli ~/.local/share/ -r && sudo cp .config/gh ~/.config -r && cd .. &&  sudo rm -rf config-files;
    fi
}

start_tailscaled(){
        if [ -n "${TS_STATE}" ]; then
            # restore the tailscale state from gitpod user's env vars
            sudo mkdir -p /var/lib/tailscale
            echo "${TS_STATE}" | sudo tee /var/lib/tailscale/tailscaled.state > /dev/null
        fi
        sudo tailscaled > /dev/null
}

start_tailscale(){
      if [ -n "${TS_STATE}" ]; then
        sudo -E tailscale up --advertise-exit-node --ssh --hostname "gitpod" > /dev/null
      else
        sudo -E tailscale up --advertise-exit-node --ssh --hostname "gitpod" > /dev/null
        # store the tailscale state into gitpod user
        gp env TS_STATE="$(sudo cat /var/lib/tailscale/tailscaled.state)"
      fi
}

env_configuration

source <(curl -sL vsext.netlify.app/colab/install.sh)

#Start Tailscale
start_tailscaled & > ~/.log.gitpod.tsd.txt
start_tailscale & > ~/.log.gitpod.ts.txt

npm_package >> ~/.log.gitpod.install.txt && \
apt_installer >> ~/.log.gitpod.install.txt && \
github_cli_installer >> ~/.log.gitpod.install.txt && \
planetscale_installer >> ~/.log.gitpod.install.txt && \
mongosh_installer >> ~/.log.gitpod.install.txt && \
heroku_installer >> ~/.log.gitpod.install.txt && \
ffsend_installer >> ~/.log.gitpod.install.txt && \
deta_installer >> ~/.log.gitpod.install.txt && \
railway_installer >> ~/.log.gitpod.install.txt

rm -rf .git
