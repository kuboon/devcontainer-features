#!/bin/bash
set -e

source dev-container-features-test-lib

check "owner" bash -c '[ "$(stat -c '%U' $(which mise))" = "mise" ]'

# Non-root user can do self-update
## TODO: The self-replace crate tries to create the /usr/local/bin/.mise.tmp file, but it results in a "Permission denied" error.
## https://github.com/mitsuhiko/self-replace/blob/8365c59b29157191e8b60022e9fe0b886affdc0d/src/unix.rs#L28
#check "version before update" bash -c 'mise version --json | [ "$(jq -r .version)" = "2025.4.1 linux-x64 (2025-04-09)" ]'
mise self-update 2025.4.2 --yes
mise version --json | jq -r .version
check "version after update" bash -c 'mise version --json | [ "$(jq -r .version)" = "2025.4.2 linux-x64 (2025-04-11)" ]'

reportResults
