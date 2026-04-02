#!/usr/bin/env bash

progname=$(basename "$0")

function usage() {
	echo -e "Usage: $progname DIR\n"
	echo -e "Given a test bench directory, generate the corresponding simulation files"
	echo -e " DIR\n\ta testbench directory"
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

# create sim dir if it doesn't exits
if [[ ! -d "./sim" ]]; then
	mkdir "./sim"
fi

for file in "$input_dir"/*.v; do
	# file = ./tb/tb_some_module_name.v
	# Strip path and tb_ prefix 
	# targ = some_module_name.v
	targ=$(basename "$file" | sed 's/^tb_//')
	message=$(cat <<EOF
module sim_$targ;
initial begin
	\$dumpfile("trace/sim_$targ")
	\$dumpvars(0, tb_${targ%.*})
end
endmodule
EOF
)
	echo "$message" > "./sim/sim_$targ"
done
exit $?
