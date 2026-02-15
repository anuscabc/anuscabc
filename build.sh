#!/usr/bin/env bash

set -e

root_dir="$(realpath "$(dirname "$0")")"
install_dir="$root_dir/bin"

# -- Ensure current repo has been fully pulled
git submodule init && git submodule update --recursive

if [ ! -f "$install_dir/zola" ]; then
    echo "Ensuring zola is installed.."
    ./install_zola.sh
fi

echo "Building website locally.."

if [ "$(uname)" == Linux ]; then
    open_cmd=xdg-open
else
    open_cmd=open
fi

bash -c "sleep 1 && $open_cmd http://localhost:1111" &
zola serve -p 1111

echo "All done! ✅"
