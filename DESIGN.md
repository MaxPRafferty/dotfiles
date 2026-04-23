# Dotfiles Design Principles

## 1. Neutrality

The repo should remain neutral. No artifacts or values explicitly tied to a specific individual should be committed. This includes but is not limited to:

- Git user name and email
- SSH keys or host-specific SSH identity references
- Work or personal account credentials or tokens
- Machine-specific paths or hostnames
- Personal API keys or secrets

Where a config file requires personal values (e.g. `.gitconfig`), commit a template with clearly marked placeholders rather than real values.
