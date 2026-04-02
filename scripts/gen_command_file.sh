#!/usr/bin/env bash

progname=$(basename "$0")

function usage(){
	echo -e "Usage: $progname DIR\n\
 Output a verilog command file with all the files under DIR.  The paths are
 transformed to be a relative path from \$PWD
 DIR\n\
\tA directory containing verilog files"
}

if [[ "$#" -lt 1 ]]; then
	usage
	exit 1
fi

input_dir=$1

# Check dir exists
if [ ! -d "$input_dir" ]; then
	echo "$progname: $input_dir doesn't exist"
	exit 1
fi

echo -n -e "/*AUTO-GENERATED USING $progname*/\n" 
find "$input_dir" \( -name '*.v' -o -name '*.sv' \)
exit $?
