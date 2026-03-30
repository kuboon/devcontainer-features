#!/bin/bash
set -e

source dev-container-features-test-lib

check "testing use -g was performed" bash -i -c 'command -v deno'

reportResults
