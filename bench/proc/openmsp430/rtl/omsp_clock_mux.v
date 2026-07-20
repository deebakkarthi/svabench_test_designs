module  omsp_clock_mux (

// OUTPUTs
    clk_out,                   // Clock output

// INPUTs
    clk_in0,                   // Clock input 0
    clk_in1,                   // Clock input 1
    reset,                     // Reset
    scan_mode,                 // Scan mode (clk_in0 is selected in scan mode)
    select                     // Clock selection
);

// OUTPUTs
//=========
output         clk_out;        // Clock output

// INPUTs
//=========
input          clk_in0;        // Clock input 0
input          clk_in1;        // Clock input 1
input          reset;          // Reset
input          scan_mode;      // Scan mode (clk_in0 is selected in scan mode)
input          select;         // Clock selection


//===========================================================================================================================//
// 1)  CLOCK MUX                                                                                                             //
//===========================================================================================================================//
//                                                                                                                           //
//    The following (glitch free) clock mux is implemented as following:                                                     //
//                                                                                                                           //
//                                                                                                                           //
//                                                                                                                           //
//                                                                                                                           //
//                                   +-----.     +--------+   +--------+                                                     //
//       select >>----+-------------O|      \    |        |   |        |          +-----.                                    //
//                    |              |       |---| D    Q |---| D    Q |--+-------|      \                                   //
//                    |     +-------O|      /    |        |   |        |  |       |       |O-+                               //
//                    |     |        +-----'     |        |   |        |  |   +--O|      /   |                               //
//                    |     |                    |   /\   |   |   /\   |  |   |   +-----'    |                               //
//                    |     |                    +--+--+--+   +--+--+--+  |   |              |                               //
//                    |     |                        O            |       |   |              |                               //
//                    |     |                        |            |       |   |              |  +-----.                      //
//       clk_in0 >>----------------------------------+------------+-----------+              +--|      \                     //
//                    |     |                                             |                     |       |----<< clk_out      //
//                    |     |     +---------------------------------------+                  +--|      /                     //
//                    |     |     |                                                          |  +-----'                      //
//                    |     +---------------------------------------------+                  |                               //
//                    |           |                                       |                  |                               //
//                    |           |  +-----.     +--------+   +--------+  |                  |                               //
//                    |           +-O|      \    |        |   |        |  |       +-----.    |                               //
//                    |              |       |---| D    Q |---| D    Q |--+-------|      \   |                               //
//                    +--------------|      /    |        |   |        |          |       |O-+                               //
//                                   +-----'     |        |   |        |      +--O|      /                                   //
//                                               |   /\   |   |   /\   |      |   +-----'                                    //
//                                               +--+--+--+   +--+--+--+      |                                              //
//                                                   O            |           |                                              //
//                                                   |            |           |                                              //
//       clk_in1 >>----------------------------------+------------+-----------+                                              //
//                                                                                                                           //
//                                                                                                                           //
//===========================================================================================================================//

//-----------------------------------------------------------------------------
// Wire declarations
//-----------------------------------------------------------------------------
   
wire in0_select;
reg  in0_select_s;
reg  in0_select_ss;
wire in0_enable;

wire in1_select;
reg  in1_select_s;
reg  in1_select_ss;
wire in1_enable;

wire clk_in0_inv;
wire clk_in1_inv;
wire gated_clk_in0;
wire gated_clk_in1;


//-----------------------------------------------------------------------------
// CLK_IN0 Selection
//-----------------------------------------------------------------------------
   
assign in0_select = ~select & ~in1_select_ss;
   
always @ (posedge clk_in0_inv or posedge reset)
  if (reset) in0_select_s  <=  1'b1;
  else       in0_select_s  <=  in0_select;

always @ (posedge clk_in0     or posedge reset)
  if (reset) in0_select_ss <=  1'b1;
  else       in0_select_ss <=  in0_select_s;

assign in0_enable = in0_select_ss | scan_mode;


//-----------------------------------------------------------------------------
// CLK_IN1 Selection
//-----------------------------------------------------------------------------
   
assign in1_select =  select & ~in0_select_ss;
   
always @ (posedge clk_in1_inv or posedge reset)
  if (reset) in1_select_s  <=  1'b0;
  else       in1_select_s  <=  in1_select;

always @ (posedge clk_in1     or posedge reset)
  if (reset) in1_select_ss <=  1'b0;
  else       in1_select_ss <=  in1_select_s;

assign in1_enable = in1_select_ss & ~scan_mode;

   
//-----------------------------------------------------------------------------
// Clock MUX
//-----------------------------------------------------------------------------
//
// IMPORTANT NOTE:
//                  Because the clock network is a critical part of the design,
//                 the following combinatorial logic should be replaced with
//                 direct instanciation of standard cells from target library.
//                  Don't forget the "dont_touch" attribute to make sure
//                 synthesis won't mess it up.
//

// Replace with standard cell INVERTER
assign clk_in0_inv   = ~clk_in0;
assign clk_in1_inv   = ~clk_in1;


// Replace with standard cell NAND2
assign gated_clk_in0 = ~(clk_in0_inv & in0_enable);
assign gated_clk_in1 = ~(clk_in1_inv & in1_enable);
   

// Replace with standard cell AND2
assign clk_out       =  (gated_clk_in0 & gated_clk_in1);



endmodule // omsp_clock_gate



