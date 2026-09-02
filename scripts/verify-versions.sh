#!/usr/bin/env bash
set -u

expected_solana="${SOLANA_FALL_SCHOOL_SOLANA_VERSION:-4.2.2}"
expected_anchor="${SOLANA_FALL_SCHOOL_ANCHOR_VERSION:-0.32.1}"
expected_rust="${SOLANA_FALL_SCHOOL_RUST_VERSION:-1.91.1}"
expected_node_major="${SOLANA_FALL_SCHOOL_NODE_VERSION:-24}"
failed=0

check() {
  local name="$1"
  local expected="$2"
  local actual="$3"
  if [ "$actual" = "$expected" ]; then
    printf 'PASS  %-8s %s\n' "$name" "$actual"
  else
    printf 'FAIL  %-8s expected %s, found %s\n' "$name" "$expected" "$actual"
    failed=1
  fi
}

if command -v rustc >/dev/null 2>&1; then
  rust_version=$(rustc --version | awk '{print $2}')
  check Rust "$expected_rust" "$rust_version"
else
  printf 'FAIL  Rust     rustc is not installed\n'
  failed=1
fi

if command -v solana >/dev/null 2>&1; then
  solana_version=$(solana --version | awk '{print $2}')
  check Solana "$expected_solana" "$solana_version"
else
  printf 'FAIL  Solana   solana is not installed\n'
  failed=1
fi

if command -v anchor >/dev/null 2>&1; then
  anchor_version=$(anchor --version | awk '{print $2}')
  check Anchor "$expected_anchor" "$anchor_version"
else
  printf 'FAIL  Anchor   anchor is not installed\n'
  failed=1
fi

if command -v node >/dev/null 2>&1; then
  node_major=$(node --version | sed 's/^v//' | cut -d. -f1)
  check Node "$expected_node_major" "$node_major"
else
  printf 'FAIL  Node     node is not installed\n'
  failed=1
fi

if [ "$failed" -ne 0 ]; then
  printf '\nEnvironment does not match the pinned course versions.\n'
  exit 1
fi

printf '\nEnvironment matches the pinned course versions.\n'
