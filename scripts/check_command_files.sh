#!/usr/bin/env bash

progname=$(basename "$0")

usage() {
	echo -e "Usage: $progname [-h | DIR]"
	echo -e " Run iverilog on all the .f files in a given DIR"
	echo -e " If no DIR is provided, run on CWD"
}

# Check if we have iverilog
if ! command -v iverilog >/dev/null 2>&1
then
	echo -ne "$progname: iverilog cannot be found\n"
	exit 1
fi

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
declare -i failed
declare -i total
declare -i curr

mapfile -t command_files_arr < <(find "$input_dir" -depth -mindepth 1 -maxdepth 1  -type f -name "*f")

total="${#command_files_arr[@]}"
curr=1
passed=0
failed=0
# Change dir because .f files have relative paths
pushd $input_dir > /dev/null
for file in "${command_files_arr[@]}"; do
	echo -en "[$curr/$total] Testing $file\n"
	if iverilog -f "$(basename $file)" >/dev/null 2>&1; then
		((passed++))
	else
		((failed++))
	fi
	((curr++))
done
echo -ne "[$passed/$total] compiled successfully\n"
rm -rf "./a.out"
# Return back to the original dir
popd > /dev/null
