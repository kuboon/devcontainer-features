#!/bin/bash
set -e

source dev-container-features-test-lib

cat /home/vscode/.config/mise/config.toml
check "testing use -g was performed" bash -i -c 'command -v deno'

reportResults
