# Architecture Overview

## Purpose
Automated provisioning and configuration of Windows Server 2022 container hosts on VMware using SaltStack.

## Workflow
1. Salt Cloud provisions VM from template.
2. Salt Minion connects and applies states:
   - Enables container features
   - Installs/updates Chocolatey
   - Installs Docker
   - Cleans up users
3. Server is ready to run Windows containers.

## Directory Structure
See repo root for descriptions.
