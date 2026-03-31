#!/bin/sh
set -e

export _REMOTE_USER="${_REMOTE_USER:-vscode}"
export _REMOTE_USER_HOME="${_REMOTE_USER_HOME:-/home/${_REMOTE_USER}}"

export MISE_INSTALL_PATH="${_REMOTE_USER_HOME}/.local/bin/mise"

# Setup postCreateCommand for mise
mkdir -p /usr/local/share/mise-feature
post_create_file="/usr/local/share/mise-feature/post-create.sh"
echo "Setting up postCreateCommand for 'mise trust'..."

if [ ! -f "$post_create_file" ]; then
    cat <<EOF >> $post_create_file
#!/bin/sh
export MISE_INSTALL_PATH=$MISE_INSTALL_PATH
if [ -x "\$(command -v mise)" ] && [ -f mise.toml ]; then
    mise trust --show
    mise install --yes
fi
EOF
    chmod +x $post_create_file
fi

if [ -e "$MISE_INSTALL_PATH" ]; then
    echo "mise installed at $MISE_INSTALL_PATH. Exiting."
    exit 0
fi

export DEBIAN_FRONTEND=noninteractive

apt_get_update() {
    if [ "$(find /var/lib/apt/lists/* | wc -l)" = "0" ]; then
        echo "Running apt-get update..."
        apt-get update -y
    fi
}

# Checks if packages are installed and installs them if not
check_packages() {
    if ! dpkg -s "$@" > /dev/null 2>&1; then
        apt_get_update
        apt-get -y install --no-install-recommends "$@"
    fi
}

install_mise_activate() {
    shell=$1
    rc=$2

    if ! command -v $shell > /dev/null 2>&1; then
        echo "(*) $shell not found. Skipping mise activate for $shell."
        return
    fi
    if [ ! -f $rc ]; then
        echo "(*) $rc not found. Skipping mise activate for $shell."
        return
    fi

    echo "Activating mise for $shell..."
    case "$ACTIVATE" in
        path)
            echo >> $rc
            echo "eval \"\$(${MISE_INSTALL_PATH} activate $shell)\"" >> $rc
            ;;
        shims)
            echo >> $rc
            echo "eval \"\$(${MISE_INSTALL_PATH} activate $shell --shims)\"" >> $rc
            ;;
    esac
}

check_packages curl ca-certificates apt-transport-https dirmngr gnupg2

# Get the directory part
install_dir=$(dirname "$MISE_INSTALL_PATH")

# Run the mise CLI installer
echo "Installing mise CLI..."
gpg --keyserver hkps://keys.openpgp.org --recv-keys 24853EC9F655CE80B48E6C3A8B81C9D17413A06D
curl https://mise.jdx.dev/install.sh.sig | gpg --decrypt | su ${_REMOTE_USER} -c "sh"
chown $_REMOTE_USER $MISE_INSTALL_PATH

install_mise_activate bash ${_REMOTE_USER_HOME}/.bashrc
install_mise_activate zsh ${_REMOTE_USER_HOME}/.zshrc
install_mise_activate fish ${_REMOTE_USER_HOME}/.config/fish/config.fish

if [ -n "$GLOBAL" ]; then
    su ${_REMOTE_USER} -c "${MISE_INSTALL_PATH} use -g ${GLOBAL}"
fi


# Clean up
rm -rf "/tmp/tmp-gnupg"
rm -rf /var/lib/apt/lists/*
