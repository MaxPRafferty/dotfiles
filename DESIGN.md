# Dotfiles Design Principles

## 1. Neutrality

The repo should remain neutral. No artifacts or values explicitly tied to a specific individual should be committed. This includes but is not limited to:

- Git user name and email
- SSH keys or host-specific SSH identity references
- Work or personal account credentials or tokens
- Machine-specific paths or hostnames
- Personal API keys or secrets

Where a config file requires personal values (e.g. `.gitconfig`), commit a template with clearly marked placeholders rather than real values.

## 2. System Neutrality

The repo should work on any supported target system without modification. Supported targets are:

- macOS
- Debian / Ubuntu
- RHEL / Fedora / CentOS
- Arch Linux

System-specific setup logic lives in its own subdirectory (`macos/`, `debian/`, `redhat/`, `arch/`). The root `setup.sh` detects the current OS and dispatches to the appropriate system script. Config files that live at the repo root (`.zshrc`, `.vimrc`, etc.) must be portable across all targets. Anything that only applies to one system belongs in that system's subdirectory.
