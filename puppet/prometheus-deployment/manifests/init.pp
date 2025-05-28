class prometheus_stack (
  Array[String] $services_to_monitor = [],
) {

  case $facts['os']['family'] {
    'RedHat': {
      include prometheus_stack::linux
    }
    'Windows': {
      include prometheus_stack::windows
    }
    default: {
      fail("Unsupported OS family: ${facts['os']['family']}")
    }
  }

  # Service monitoring (for both platforms)
  if $services_to_monitor != [] {
    class { 'prometheus_stack::service_monitoring':
      services => $services_to_monitor,
    }
  }
}
