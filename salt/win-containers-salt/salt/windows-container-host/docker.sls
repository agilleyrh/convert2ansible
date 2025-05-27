install_docker:
  chocolatey.installed:
    - name: docker
    - version: latest

start_docker_service:
  service.running:
    - name: docker
