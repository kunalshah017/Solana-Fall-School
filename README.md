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

Install or select the upstream tools if needed:

```bash
avm install 0.32.1
avm use 0.32.1
agave-install init 4.2.2
```

Then verify the complete environment from inside `nix develop`:

```bash
./scripts/verify-versions.sh
```

The first `nix develop` generates `flake.lock`; commit that file so every
student uses the same nixpkgs revision.
