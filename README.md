# vscode-devcontainer
A dev container based on debian and [workstation](https://github.com/zrob/workstation).

Intended to be used as a vscode dev container.

## Usage

Copy the `Dockerfile` into the project's `.devcontainer/` directory.

Use vscode to create a devcontainer.json or use one from this repo.

## Building

`Dockerfile.base` sets up the base image which is pushed to `zrob/vscode-base`.

The `bin/` folder has some helpers for building and updating the image.

Most scripts operate on a local image named `vscode-base`. The `tag` script will tag the latest `vscode-base` as `zrob/vscode-base` to be pushed up once the image is in a good state.

* `build` - Build `Dockerfile.base` as `vscode-base`
* `rebuild` - Rebuild `Dockerfile.base` as `vscode-base` from scratch
* `connect` - Open a shell to `vscode-base` to validate any changes
* `reset-image` - Reset `vscode-base` working image to match `zrob/vscode-base`
* `update-station` - Run the `station` command on `vscode-base`
* `tag` - Tag `vscode-base` as `zrob/vscode-base`
