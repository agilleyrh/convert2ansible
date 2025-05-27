provision_windows_container_host:
  salt.cloud.profile:
    - name: win2022-container-host
    - profile: win2022-container-host

apply_windows_container_state:
  salt.state:
    - tgt: 'win2022-container-*'
    - sls:
      - windows-container-host
    - require:
      - salt: provision_windows_container_host
