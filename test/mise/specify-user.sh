#!/bin/bash
set -e

source dev-container-features-test-lib

check "owner" bash -c '[ "$(stat -c '%U' $(which mise))" = "mise" ]'

mise self-update 2025.4.2 --yes
mise version --json | jq -r .version
check "version after update" bash -c 'mise version --json | jq -e ".version | startswith(\"2025.4.2\")"'

reportResults
