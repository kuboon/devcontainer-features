#!/bin/bash
set -e

source dev-container-features-test-lib

cat /usr/local/share/mise-feature/post-create.sh

check "no problems in doctor" bash -c "mise doctor | grep 'No problems found'"
check "owner" bash -c '[ "$(stat -c '%U' $(which mise))" = "vscode" ]'

reportResults
