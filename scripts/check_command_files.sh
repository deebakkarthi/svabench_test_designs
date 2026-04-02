#!/usr/bin/env bash

progname=$(basename "$0")

usage() {
	echo -e "Usage: $progname [-h | DIR]"
	echo -e " Run iverilog on all the .f files in a given DIR"
	echo -e " If no DIR is provided, run on CWD"
}

input_dir="."
if [[ "$#" -gt 0 ]]; then
	if [[ "$1" == "-h" ]]; then
		usage
		exit 0
	else
		input_dir="$1"
	fi
fi

if [[ ! -d "$input_dir" ]]; then
	echo -e "$progname: $input_dir doesn't exist"
	exit 1
fi


declare -i passed
declare -i total
declare -i curr
total=$(find "$input_dir" -depth -mindepth 1 -maxdepth 1  -type f -name "*f" | wc -l)
curr=1
for file in "$input_dir"/*.f; do
	echo -en "[$curr/$total] Testing $file\033[K\r"
	if iverilog -f "$file" >/dev/null 2>&1; then
		((passed++))
	fi
	((curr++))
done
echo -e "\033[K\r[$passed/$total] compiled successfully"
rm -rf "./a.out"
