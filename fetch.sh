#!/usr/bin/env bash

urls=()
# Check if the URLs are reachable
while read -r p; do
	git ls-remote "$p" >/dev/null 2>&1 && urls+=("$p")
done <URLS.txt

for url in "${urls[@]}"; do
	# We don't care about history
	git clone --depth 1 --recurse-submodules --shallow-submodules "$url"
done
