# Windows Container Host Salt Automation

This repo automates the deployment and configuration of Windows Server 2022 hosts for running containers in a VMware environment using SaltStack.

## Quick Start

1. Review and customize the Salt Cloud and state files under `salt/` and `cloud/`.
2. Add any secrets or sensitive pillar values to `pillar/windows-container-host.sls` (not committed by default).
3. Provision new VMs and apply states as needed.

See `docs/architecture.md` for a full overview.
