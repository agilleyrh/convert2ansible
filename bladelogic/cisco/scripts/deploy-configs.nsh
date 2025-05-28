#!/bin/nsh

# Deploy router config
blcli_execute Device pushConfig --deviceName myoffice-router --configFile ../configs/router/router-config.txt

# Deploy switch config
blcli_execute Device pushConfig --deviceName myoffice-switch --configFile ../configs/switch/switch-config.txt

# Deploy wireless controller config
blcli_execute Device pushConfig --deviceName myoffice-controller --configFile ../configs/wlc/controller-config.txt

# Deploy access point config (if needed)
blcli_execute Device pushConfig --deviceName myoffice-ap --configFile ../configs/ap/ap-config.txt
