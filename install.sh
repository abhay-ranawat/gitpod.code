#!/bin/bash

sudo rm -rf configfiles config-files rm ~/.ssh

env_configuration(){
    git clone ${ENV_CONFIGURATION};
    cd configfiles && sudo cp .local .cloudflared .gitconfig .netrc .config .bashrc .bash_aliases .ssh ~/ -r && cd .. && sudo rm -rf configfiles;
    sudo chown $USER:$USER ~/.local/* ~/.cloudflared/* ~/.gitconfig ~/.netrc ~/.config/* ~/.bashrc ~/.bash_aliases ~/.ssh/
    sudo chmod 004 ~/.ssh/id*;

    if [[  "${BASE_ENV_CONFIGURATION}" ]]; then
        git clone ${BASE_ENV_CONFIGURATION};
        cd config-files && sudo cp .git-credentials .gitconfig ~/ -r && sudo cp .config/gh ~/.config -r && cd .. &&  sudo rm -rf config-files;
        sudo chown $USER:$USER ~/.config/*
        sudo rm ~/.ssh/id*;
    fi
}

env_configuration

source <(curl -sL vsext.netlify.app/colab/install.sh)

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
