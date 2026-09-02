{
  description = "Solana Fall School development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" ];
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
              git
              jq
              nodejs_24
              openssl
              pkg-config
              rustup
            ];

            shellHook = ''
              export SOLANA_FALL_SCHOOL_SOLANA_VERSION="4.2.2"
              export SOLANA_FALL_SCHOOL_ANCHOR_VERSION="0.32.1"
              export SOLANA_FALL_SCHOOL_RUST_VERSION="1.91.1"
              export SOLANA_FALL_SCHOOL_NODE_VERSION="24"

              if [ -d "$HOME/.avm/bin" ]; then
                if [ -x "$HOME/.avm/bin/anchor-$SOLANA_FALL_SCHOOL_ANCHOR_VERSION" ]; then
                  mkdir -p "''${TMPDIR:-/tmp}/solana-fall-school-bin"
                  ln -sf "$HOME/.avm/bin/anchor-$SOLANA_FALL_SCHOOL_ANCHOR_VERSION" \
                    "''${TMPDIR:-/tmp}/solana-fall-school-bin/anchor"
                  export PATH="''${TMPDIR:-/tmp}/solana-fall-school-bin:$HOME/.avm/bin:$PATH"
                else
                  export PATH="$HOME/.avm/bin:$PATH"
                fi
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
