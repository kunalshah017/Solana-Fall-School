# Solana Fall School Environment

This project uses Nix to provide a repeatable WSL development shell. The
Solana and Anchor versions are checked explicitly because they are distributed
through Agave and AVM rather than reliably through nixpkgs.

Pinned versions:

- Rust `1.91.1`
- Solana/Agave CLI `4.2.2`
- Anchor CLI `0.32.1`
- Node.js `24.x`

## Setup

Enter the repository in WSL and start the Nix shell:

```bash
nix develop
```

The first `nix develop` automatically installs and selects the pinned Agave and
Anchor versions using their official installers. Then verify the complete
environment:

```bash
./scripts/verify-versions.sh
```

The first `nix develop` generates `flake.lock`; commit that file so every
student uses the same nixpkgs revision.
