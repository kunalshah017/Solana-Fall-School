{
  description = "Solana Fall School development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in {
      devShells = forAllSystems (system:
        let
          pkgs = import nixpkgs { inherit system; };
        in {
          default = pkgs.mkShell {
            packages = with pkgs; [
              bash
              coreutils
              curl
              git
              gnugrep
              jq
              nodejs_24
              openssl
              pnpm
              pkg-config
              rustup
            ];

            shellHook = ''
              export SOLANA_FALL_SCHOOL_SOLANA_VERSION="4.2.2"
              export SOLANA_FALL_SCHOOL_ANCHOR_VERSION="0.32.1"
              export SOLANA_FALL_SCHOOL_RUST_VERSION="1.91.1"
              export SOLANA_FALL_SCHOOL_NODE_VERSION="24"

              export PATH="$HOME/.cargo/bin:$HOME/.avm/bin:$HOME/.local/share/solana/install/active_release/bin:$PATH"

              if ! command -v agave-install >/dev/null 2>&1; then
                printf 'Installing the Agave installer...\n'
                curl --proto '=https' --tlsv1.2 -sSfL \
                  https://release.anza.xyz/stable/install | bash
                export PATH="$HOME/.local/share/solana/install/active_release/bin:$PATH"
              fi

              if ! command -v solana >/dev/null 2>&1 || \
                [ "$(solana --version | awk '{print $2}')" != "$SOLANA_FALL_SCHOOL_SOLANA_VERSION" ]; then
                config="$HOME/.config/solana/install/config.yml"
                if [ -f "$config" ] && ! grep -q '^json_rpc_url:' "$config"; then
                  mv "$config" "$config.bak"
                fi
                agave-install init "$SOLANA_FALL_SCHOOL_SOLANA_VERSION"
                export PATH="$HOME/.local/share/solana/install/active_release/bin:$PATH"
              fi

              if ! command -v avm >/dev/null 2>&1; then
                printf 'Installing AVM...\n'
                cargo install --git https://github.com/coral-xyz/avm avm --force
              fi

              if [ ! -x "$HOME/.avm/bin/anchor-$SOLANA_FALL_SCHOOL_ANCHOR_VERSION" ]; then
                avm install "$SOLANA_FALL_SCHOOL_ANCHOR_VERSION"
                avm use "$SOLANA_FALL_SCHOOL_ANCHOR_VERSION"
              fi

              if [ -x "$HOME/.avm/bin/anchor-$SOLANA_FALL_SCHOOL_ANCHOR_VERSION" ]; then
                mkdir -p "''${TMPDIR:-/tmp}/solana-fall-school-bin"
                ln -sf "$HOME/.avm/bin/anchor-$SOLANA_FALL_SCHOOL_ANCHOR_VERSION" \
                  "''${TMPDIR:-/tmp}/solana-fall-school-bin/anchor"
                export PATH="''${TMPDIR:-/tmp}/solana-fall-school-bin:$HOME/.avm/bin:$PATH"
              fi

              if [ -f "$PWD/scripts/verify-versions.sh" ]; then
                printf '\nSolana Fall School environment loaded.\n'
                printf 'Run: ./scripts/verify-versions.sh\n\n'
              fi
            '';
          };
        });
    };
}
