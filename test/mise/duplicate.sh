#!/bin/bash
set -e

source dev-container-features-test-lib

MISE_INSTALL_PATH=~/.local/bin/mise
eval $($MISE_INSTALL_PATH activate bash)

check "no problems in doctor" bash -c "mise doctor | grep 'shell:'"
stat -c '%U' $(which mise)
check "owner" bash -c '[ "$(stat -c '%U' $(which mise))" = "$(whoami)" ]'

reportResults
