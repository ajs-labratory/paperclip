#!/bin/sh
set -e

PUID=${USER_UID:-1000}
PGID=${USER_GID:-1000}

if [ "$(id -u node)" -ne "$PUID" ]; then
    echo "Updating node UID to $PUID"
    usermod -o -u "$PUID" node
fi
if [ "$(id -g node)" -ne "$PGID" ]; then
    echo "Updating node GID to $PGID"
    groupmod -o -g "$PGID" node
    usermod -g "$PGID" node
fi

# Create required directories FIRST (as root)...
mkdir -p /paperclip/instances/default/logs

# ...THEN claim ownership of everything, including the just-created dirs
chown -R node:node /paperclip

exec gosu node "$@"
