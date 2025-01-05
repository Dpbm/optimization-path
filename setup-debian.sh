#!/bin/bash

sudo apt update && sudo apt upgrade -y
sudo apt install r-base r-base-dev curl libcurl4-openssl-dev graphviz -y


if [ ! $(which rstudio) &>/dev/null ]
then
    echo "Installing RStudio..."

    RSTUDIO_DOWNLOAD_URL = "https://download1.rstudio.org/electron/jammy/amd64/rstudio-2024.09.1-394-amd64.deb"
    TARGET_DEB_FILE_PATH = "/tmp/rstudio.deb"

    curl -L -o $TARGET_DEB_FILE_PATH $RSTUDIO_DOWNLOAD_URL
    sudo apt install $TARGET_DEB_FILE_PATH -y
fi
