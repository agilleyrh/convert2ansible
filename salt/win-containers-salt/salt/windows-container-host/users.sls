# Remove all local users except Administrator and ensure Administrator has a known password
{% set admin_password = salt['pillar.get']('windows_container_host:admin_password', 'ReplaceMe123!') %}

set_admin_password:
  user.present:
    - name: Administrator
    - password: "{{ admin_password }}"

remove_other_users:
  cmd.run:
    - name: "for /F \"tokens=*\" %u in ('net user ^| findstr /B /C:\" \" ^| findstr /V \"Administrator\"') do net user \"%u\" /delete"
    - shell: cmd
