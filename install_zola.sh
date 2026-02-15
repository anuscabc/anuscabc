#!/usr/bin/env bash

set -e

on_exit(){
    if [ ! $? -eq 0 ]; then
        echo "😞 Sorry, the script encountered an error!"
        echo -e "Result of uname -a:\n$(uname -a)"
        echo "⬆ Please copy all the text above and send us an email! ⬆ "
        exit 1
    fi
}

trap "on_exit" EXIT

root_dir="$(realpath "$(dirname "$0")")"
echo "Current directory is: $root_dir"

# -- Detect platform/architecture
zola_root_url=https://github.com/getzola/zola/releases/download/v0.22.1

echo -n "Understanding what machine you're on.. "

archive_name=''
if [ "$(uname)" == Linux ]; then
    archive_name=zola-v0.22.1-x86_64-unknown-linux-gnu.tar.gz
else
    if [ "$(arch)" == arm64 ]; then
        archive_name=zola-v0.22.1-aarch64-apple-darwin.tar.gz
    else
        archive_name=zola-v0.22.1-x86_64-apple-darwin.tar.gz
    fi
fi

if [ -z "$archive_name" ]; then
    echo -e "\n❌ Failed to understand what platform and architecture you're on."
    exit 1
fi 

echo "✅"

# -- Download zola
downloads_dir="$root_dir/tmp/downloads"
if [ -d "$downloads_dir" ]; then
    rm -rf "$downloads_dir"
fi
mkdir -p "$downloads_dir"

echo "Downloading zola (the website generator) ..."
curl -L -f "$zola_root_url/$archive_name" -o "$root_dir/tmp/downloads/$archive_name"
echo "Download complete! ✅"

cd "$downloads_dir" || exit 1 
tar -xvf "$archive_name"

# -- Final installation
echo -n "Installing zola.."
install_dir="$root_dir/bin"
mkdir -p  "$install_dir"
mv "$downloads_dir/zola" "$install_dir/zola"
chmod +x "$install_dir/zola"
echo '✅'

echo -n "Version of zola installed: "
"$install_dir/zola" --version

echo "All done! ✅"
