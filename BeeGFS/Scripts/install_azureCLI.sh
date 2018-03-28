#!/bin/bash
curl --silent --location https://rpm.nodesource.com/setup_4.x | bash -
        yum -y install nodejs

        [[ -z "$HOME" || ! -d "$HOME" ]] && { echo 'fixing $HOME'; HOME=/root; }
        export HOme
        npm install -g azure-cli
        azure telemetry --disable
