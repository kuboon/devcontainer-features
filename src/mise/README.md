
# mise-en-place (mise)

Installs the mise CLI

## Example Usage

```json
"features": {
    "ghcr.io/kuboon/devcontainer-features/mise:1": {}
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| global | `mise use -g [args]` to install global tools. For example, `deno ruby lazygit lazydocker cargo:cargo-binstall`. | string | lazygit@latest |
| activate | Select how to activate mise in the system. `none` means no activation, `path` means add to PATH, and `shims` means use shims to activate. Supports bash and zsh. | string | shims |

## Customizations

### VS Code Extensions

- `hverlin.mise-vscode`

## Notes

To trust all `mise.toml` files including those in workspace subdirectories, add the following to your `devcontainer.json`:

```json
"containerEnv": {
    "MISE_TRUSTED_CONFIG_PATHS": "${containerWorkspaceFolder}"
}
```


---

_Note: This file was auto-generated from the [devcontainer-feature.json](devcontainer-feature.json).  Add additional notes to a `NOTES.md`._
