# My Dev Container Features

These are devcontainer features that I wanted, so I made them.

## Contents

Here are the features:

### `helix-editor`

The `helix-editor` feature installs [Helix](https://helix-editor.com).

```jsonc
{
    "image": "mcr.microsoft.com/devcontainers/base:ubuntu",
    "features": {
        "ghcr.io/ilkka/devcontainer-features/helix-editor:1": {
            "helixVersion": "22.12"
        }
    }
}
```

```bash
$ hx --version
helix 22.12 (96ff64a8)
```
