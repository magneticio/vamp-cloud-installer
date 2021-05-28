# vamp-cloud-installer
Vamp Cloud Agent Installer for Kubernetes

Invoke the installer as described here: https://docs.vamp.cloud/release-agent/installation#installing-the-release-agent

## Automated Testing

Tests are written using the [bats](https://github.com/bats-core/bats-core) testing framework.
Bats can be installed in macos via homebrew with `brew install bats-core`, see the bats documentation for [installation on other operating systems](https://bats-core.readthedocs.io/en/latest/installation.html).

Test files should be written to the `test/` directory and given the extenion `.bats`.

### Running the tests

Invoke `bats` from the root directory of the checkout
```
$ bats test/
```
