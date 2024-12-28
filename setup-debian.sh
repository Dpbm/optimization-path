#!/bin/bash

sudo apt update && sudo apt upgrade -y
sudo apt install r-base r-base-dev curl libcurl4-openssl-dev -y

curl -L -o /tmp/rstudio.deb https://download1.rstudio.org/electron/jammy/amd64/rstudio-2024.09.1-394-amd64.deb
sudo apt install /tmp/rstudio.deb -y
