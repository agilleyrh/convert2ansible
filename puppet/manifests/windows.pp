class prometheus_stack::windows {

  $prometheus_version = '2.52.0'
  $prometheus_url = "https://github.com/prometheus/prometheus/releases/download/v${prometheus_version}/prometheus-${prometheus_version}.windows-amd64.zip"
  $prometheus_zip = "C:/Temp/prometheus-${prometheus_version}.zip"
  $prometheus_dir = "C:/Prometheus"

  file { 'C:/Temp':
    ensure => directory,
  }

  exec { 'download_prometheus_win':
    command => "powershell.exe -Command \"Invoke-WebRequest -OutFile ${prometheus_zip} -Uri ${prometheus_url}\"",
    creates => $prometheus_zip,
    require => File['C:/Temp'],
  }

  exec { 'extract_prometheus_win':
    command => "powershell.exe -Command \"Expand-Archive -Path ${prometheus_zip} -DestinationPath C:/Temp -Force\"; Move-Item -Path C:/Temp/prometheus-${prometheus_version}.windows-amd64 -Destination ${prometheus_dir} -Force",
    creates => $prometheus_dir,
    require => Exec['download_prometheus_win'],
  }

  # Windows exporter (for hardware metrics)
  $win_exporter_version = '0.24.0'
  $win_exporter_url = "https://github.com/prometheus-community/windows_exporter/releases/download/v${win_exporter_version}/windows_exporter-${win_exporter_version}-amd64.msi"
  $win_exporter_msi = "C:/Temp/windows_exporter-${win_exporter_version}-amd64.msi"

  exec { 'download_win_exporter':
    command => "powershell.exe -Command \"Invoke-WebRequest -OutFile ${win_exporter_msi} -Uri ${win_exporter_url}\"",
    creates => $win_exporter_msi,
    require => File['C:/Temp'],
  }

  package { 'windows_exporter':
    ensure   => installed,
    source   => $win_exporter_msi,
    provider => 'windows',
    require  => Exec['download_win_exporter'],
  }

  file { 'C:/Prometheus/prometheus.yml':
    ensure  => file,
    content => template('prometheus_stack/prometheus.win.yml.erb'),
    require => Exec['extract_prometheus_win'],
  }

  # Prometheus as a service (nssm is recommended)
  $nssm_url = "https://nssm.cc/release/nssm-2.24.zip"
  $nssm_zip = "C:/Temp/nssm-2.24.zip"
  $nssm_exe = "C:/nssm/nssm.exe"

  exec { 'download_nssm':
    command => "powershell.exe -Command \"Invoke-WebRequest -OutFile ${nssm_zip} -Uri ${nssm_url}\"",
    creates => $nssm_zip,
  }

  exec { 'extract_nssm':
    command => "powershell.exe -Command \"Expand-Archive -Path ${nssm_zip} -DestinationPath C:/nssm -Force\"",
    creates => $nssm_exe,
    require => Exec['download_nssm'],
  }

  exec { 'install_prometheus_service':
    command => "C:/nssm/nssm.exe install prometheus \"${prometheus_dir}/prometheus.exe\"",
    unless  => "sc.exe query prometheus",
    require => [Exec['extract_prometheus_win'], Exec['extract_nssm']],
  }

  service { 'prometheus':
    ensure   => running,
    enable   => true,
    provider => 'windows',
    require  => Exec['install_prometheus_service'],
  }
}
