clear -all

analyze -sv -f i2c.f

if { [file exists i2c_sva.f] == 1 } {
	analyze -sv -f i2c_sva.f
}

elaborate
clock wb_clk_i
reset -none

prove -all
llength [get_property_list -include {type {assert} status {proven} related_cover_status {green white}}]
exit
