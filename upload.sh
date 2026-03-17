#!/usr/bin/env bash

set -e

if [ "$(git branch | grep '*' | awk '{print $2}')" != main ]; then
    echo "Please go back to the main branch, if you can!"
    echo "Run: git checkout main"
    exit 1
fi

echo "Building website..."
root_dir="$(realpath "$(dirname "$0")")"
install_dir="$root_dir/bin"
"$install_dir/zola" build

git add static public content

commit_msg="Update website: $(date +%Y-%m-%d-%H-%m-%S)"
git diff --cached --quiet || git commit -m "$commit_msg"

git push origin main

echo "Done! Changes will be live at https://anapopovici.me in ~1 minute."