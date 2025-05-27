install_chocolatey:
  chocolatey.bootstrap:
    - force: True

upgrade_all_choco:
  chocolatey.upgrade:
    - name: all
