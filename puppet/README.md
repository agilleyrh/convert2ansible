# Prometheus Stack Puppet Module

This module installs and configures Prometheus and exporters on both Linux (RHEL) and Windows Server, and supports hardware & service monitoring out of the box.

## Features
- Prometheus installation & service management
- Node Exporter (Linux hardware monitoring)
- Windows Exporter (Windows hardware monitoring)
- Blackbox Exporter (service monitoring, Linux)
- Service monitoring for both platforms (set `services_to_monitor`)
- Uses systemd (Linux) or nssm (Windows) for service mgmt

## Usage

```puppet
class { 'prometheus_stack':
  services_to_monitor => ['http://localhost:80', 'http://localhost:443'],
}

