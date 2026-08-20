clear -all

analyze -sv -f sockit_owm.f

if { [file exists sockit_owm_sva.f] == 1 } {
	analyze -sv -f sockit_owm_sva.f
}

elaborate
clock clk
reset rst

prove -all
llength [get_property_list -include {type {assert} status {proven} related_cover_status {green white}}]
exit
