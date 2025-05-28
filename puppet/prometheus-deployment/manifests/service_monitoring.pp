class prometheus_stack::service_monitoring (
  Array[String] $services,
) {

  case $facts['os']['family'] {
    'RedHat': {
      # Install and configure blackbox exporter for service checks
      $blackbox_version = '0.25.0'
      $blackbox_url = "https://github.com/prometheus/blackbox_exporter/releases/download/v${blackbox_version}/blackbox_exporter-${blackbox_version}.linux-amd64.tar.gz"
      $blackbox_tar = "/tmp/blackbox_exporter-${blackbox_version}.tar.gz"
      $blackbox_dir = "/opt/blackbox_exporter"

      exec { 'download_blackbox_exporter':
        command => "/usr/bin/wget -O ${blackbox_tar} ${blackbox_url}",
        creates => $blackbox_tar,
      }

      exec { 'extract_blackbox_exporter':
        command => "/bin/tar xzf ${blackbox_tar} -C /opt && mv /opt/blackbox_exporter-${blackbox_version}.linux-amd64 ${blackbox_dir}",
        creates => $blackbox_dir,
        require => Exec['download_blackbox_exporter'],
      }

      file { '/etc/systemd/system/blackbox_exporter.service':
        ensure  => file,
        content => template('prometheus_stack/blackbox_exporter.service.erb'),
        require => Exec['extract_blackbox_exporter'],
      }

      service { 'blackbox_exporter':
        ensure    => running,
        enable    => true,
        subscribe => File['/etc/systemd/system/blackbox_exporter.service'],
      }

      # Services list for blackbox exporter: write to a config file for Prometheus to use
      file { '/etc/prometheus/monitored_services.yml':
        ensure  => file,
        content => inline_template("<% @services.each do |svc| -%>\n- <%= svc %>\n<% end -%>"),
        require => File['/etc/prometheus'],
      }

    }
    'Windows': {
      # On Windows, can be monitored by windows_exporter (service collector)
      # Services to monitor are added to the Prometheus config (see template)
      # Nothing to do here: handled by template logic
    }
  }
}
