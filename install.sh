 #!/bin/bash

source <(curl -sL vsext.netlify.app/colab/install.sh)

env_configuration
code_server_user_configuration

export setup_packages=("npm_package" "apt_installer" "github_cli_installer" "planetscale_installer" "mongosh_installer")
export setup_bg_packages=("heroku_installer" "ffsend_installer" "deta_installer" "railway_installer")

setup_env &