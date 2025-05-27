# Bootstrap Salt Minion on Windows
$ErrorActionPreference = 'Stop'
Invoke-WebRequest -Uri "https://repo.saltproject.io/salt/py3/win/3006/Salt-Minion-3006-Py3-AMD64-Setup.exe" -OutFile "$env:TEMP\salt-minion.exe"
Start-Process -Wait -FilePath "$env:TEMP\salt-minion.exe" -ArgumentList '/S', '/master=saltmaster.yourdomain.local'
