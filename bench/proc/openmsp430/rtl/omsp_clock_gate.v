module  omsp_clock_gate (

// OUTPUTs
    gclk,                      // Gated clock

// INPUTs
    clk,                       // Clock
    enable,                    // Clock enable
    scan_enable                // Scan enable (active during scan shifting)
);

// OUTPUTs
//=========
output         gclk;           // Gated clock

// INPUTs
//=========
input          clk;            // Clock
input          enable;         // Clock enable
input          scan_enable;    // Scan enable (active during scan shifting)


//=============================================================================
// CLOCK GATE: LATCH + AND
//=============================================================================
   
// Enable clock gate during scan shift
// (the gate itself is checked with the scan capture cycle)
wire    enable_in =   (enable | scan_enable);

// LATCH the enable signal
reg     enable_latch;
always @(clk or enable_in)
  if (~clk)
    enable_latch <= enable_in;

// AND gate
assign  gclk      =  (clk & enable_latch);


endmodule // omsp_clock_gate


