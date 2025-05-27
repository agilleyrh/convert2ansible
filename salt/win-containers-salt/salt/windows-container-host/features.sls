enable_container_features:
  win_feature.installed:
    - names:
      - Containers
      - Hyper-V
      - Microsoft-Hyper-V-Management-PowerShell

reboot_if_needed:
  module.run:
    - name: system.reboot
    - onlyif:
      - test_reboot_needed.win
