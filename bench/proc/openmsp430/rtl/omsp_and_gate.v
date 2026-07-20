module  omsp_and_gate (

// OUTPUTs
    y,                         // AND gate output

// INPUTs
    a,                         // AND gate input A
    b                          // AND gate input B
);

// OUTPUTs
//=========
output         y;              // AND gate output

// INPUTs
//=========
input          a;              // AND gate input A
input          b;              // AND gate input B


//=============================================================================
// 1)  SOME COMMENTS ON THIS MODULE
//=============================================================================
//
//    In its ASIC version, some combinatorial pathes of the openMSP430 are
// sensitive to glitches, in particular the ones generating the wakeup
// signals.
//    To prevent synthesis from optmizing combinatorial clouds into glitchy
// logic, this AND gate module has been instanciated in the critical places.
//
//    Make sure that synthesis doesn't ungroup this module. As an alternative,
// a standard cell from the library could also be directly instanciated here
// (don't forget the "dont_touch" attribute)
//
//
//=============================================================================
// 2)  AND GATE
//=============================================================================

assign  y  =  a & b;


endmodule // omsp_and_gate



