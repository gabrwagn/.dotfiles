#!/usr/bin/env bash
# Install greeter.toml into the greeter's state directory.
#
# This cannot be stowed: /var/lib/noctalia-greeter is owned by the `greeter`
# account, and $HOME is mode 700, so a symlink into this repo would be
# unreadable at the login screen and the greeter would fall back to defaults.
#
# The copr package also never creates the state directory, so this does it.
#
# Appearance itself comes from Noctalia Sync. On noctalia 5.0.1 the Settings
# "Sync Now" button fails: it calls the helper through run0 with the legacy
# positional syntax and stages [[session.actions]], both rejected by the
# constrained helper. Until the next release, sync by hand:
#
#   noctalia msg greeter-sync            # stages files, then fails
#   staging=/run/user/$(id -u)/noctalia-greeter-sync
#   sed -i '/^\[\[session\.actions\]\]/,$d' "$staging/sync.toml"
#   pkexec /usr/bin/noctalia-greeter-apply-appearance --sync "$staging"
set -euo pipefail

src="$(dirname "$(realpath "$0")")/greeter.toml"

pkexec /bin/sh -c "
    install -d -o greeter -g greeter -m 0755 /var/lib/noctalia-greeter &&
    install -o greeter -g greeter -m 0644 '$src' /var/lib/noctalia-greeter/greeter.toml
"

echo "installed greeter.toml; log out or restart greetd to see it"
