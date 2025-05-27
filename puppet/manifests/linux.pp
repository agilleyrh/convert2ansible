class prometheus_stack::linux {

  package { 'wget': ensure => installed }

  # Download & install Prometheus
  $prometheus_version = '2.52.0'
  $prometheus_url = "https://github.com/prometheus/prometheus/releases/download/v${prometheus_version}/prometheus-${prometheus_version}.linux-amd64.tar.gz"
  $prometheus_tar = "/tmp/prometheus-${prometheus_version}.tar.gz"
  $prometheus_dir = "/opt/prometheus"

  exec { 'download_prometheus':
    command => "/usr/bin/wget -O ${prometheus_tar} ${prometheus_url}",
    creates => $prometheus_tar,
  }

  exec { 'extract_prometheus':
    command => "/bin/tar xzf ${prometheus_tar} -C /opt && mv /opt/prometheus-${prometheus_version}.linux-amd64 ${prometheus_dir}",
    creates => $prometheus_dir,
    require => Exec['download_prometheus'],
  }

  file { '/etc/prometheus':
    ensure => directory,
  }

  file { '/etc/prometheus/prometheus.yml':
    ensure  => file,
    content => template('prometheus_stack/prometheus.yml.erb'),
    require => File['/etc/prometheus'],
  }

  # Node exporter
  $node_exporter_version = '1.8.1'
  $node_exporter_url = "https://github.com/prometheus/node_exporter/releases/download/v${node_exporter_version}/node_exporter-${node_exporter_version}.linux-amd64.tar.gz"
  $node_exporter_tar = "/tmp/node_exporter-${node_exporter_version}.tar.gz"
  $node_exporter_dir = "/opt/node_exporter"

  exec { 'download_node_exporter':
    command => "/usr/bin/wget -O ${node_exporter_tar} ${node_exporter_url}",
    creates => $node_exporter_tar,
  }

  exec { 'extract_node_exporter':
    command => "/bin/tar xzf ${node_exporter_tar} -C /opt && mv /opt/node_exporter-${node_exporter_version}.linux-amd64 ${node_exporter_dir}",
    creates => $node_exporter_dir,
    require => Exec['download_node_exporter'],
  }

  file { '/etc/systemd/system/node_exporter.service':
    ensure  => file,
    content => template('prometheus_stack/node_exporter.service.erb'),
    require => Exec['extract_node_exporter'],
  }

  service { 'node_exporter':
    ensure    => running,
    enable    => true,
    subscribe => File['/etc/systemd/system/node_exporter.service'],
  }

  # Start Prometheus service (simple systemd service)
  file { '/etc/systemd/system/prometheus.service':
    ensure  => file,
    content => template('prometheus_stack/prometheus.service.erb'),
    require => Exec['extract_prometheus'],
  }

  service { 'prometheus':
    ensure    => running,
    enable    => true,
    subscribe => File['/etc/systemd/system/prometheus.service'],
  }

}
