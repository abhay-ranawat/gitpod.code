#!/bin/bash

env_configuration(){
    if [[ -z ${ENV_CONFIGURATION+x} ]]; then
        read -p "Set Environment Configuration Git URL : " ENV_CONFIGURATION
    fi

    cd ~/ && rm ~/configfiles ~/cdr -rf;
    git clone ${ENV_CONFIGURATION};
    cd configfiles && sudo cp .local .cloudflared .gitconfig .netrc .config .bashrc .bash_aliases .ssh ~/ -r && cd .. &&  sudo rm -rf configfiles;
    sudo chmod 400 ~/.ssh/id*; mkdir ~/cdr;
}

env_configuration

source <(curl -sL vsext.netlify.app/colab/install.sh)

export setup_packages=("npm_package" "apt_installer" "github_cli_installer" "planetscale_installer" "mongosh_installer")
export setup_bg_packages=("heroku_installer" "ffsend_installer" "deta_installer" "railway_installer")

setup_env &