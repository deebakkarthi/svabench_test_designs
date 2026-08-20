clear -all

analyze -sv -f sha3.f

if { [file exists sha3_sva.f] == 1 } {
	analyze -sv -f sha3_sva.f
}

elaborate
clock clk
reset -none

prove -all
llength [get_property_list -include {type {assert} status {proven} related_cover_status {green white}}]
exit
