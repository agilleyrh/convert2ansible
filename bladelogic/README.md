# BladeLogic Cisco Office Automation

This repository contains example BladeLogic Automation scripts and configuration templates to deploy a small office Cisco network stack:

**Devices:**
- Cisco ISR 4331 Router
- Cisco Catalyst 9300 Switch
- Cisco 9800-L Wireless Controller
- Cisco Catalyst 9105AXI Access Points

**Features:**
- Preconfigured for a small business office
- WiFi SSID: `mybusiness`
- Example BladeLogic NSH script to automate deployment

**Directory Structure:**
```
configs/
  router/
    router-config.txt
  switch/
    switch-config.txt
  wlc/
    controller-config.txt
  ap/
    ap-config.txt
scripts/
  deploy-configs.nsh
```

**How to use:**
1. Review and edit the config templates to fit your environment and credentials.
2. Use the `deploy-configs.nsh` NSH script with BladeLogic to push configs.
3. Always change default passwords and security settings before deploying in production!

