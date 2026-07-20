module  omsp_sync_reset (

// OUTPUTs
    rst_s,                        // Synchronized reset

// INPUTs
    clk,                          // Receiving clock
    rst_a                         // Asynchronous reset
);

// OUTPUTs
//=========
output              rst_s;        // Synchronized reset

// INPUTs
//=========
input               clk;          // Receiving clock
input               rst_a;        // Asynchronous reset


//=============================================================================
// 1)  SYNCHRONIZER
//=============================================================================

reg    [1:0] data_sync;

always @(posedge clk or posedge rst_a)
  if (rst_a) data_sync <=  2'b11;
  else       data_sync <=  {data_sync[0], 1'b0};

assign       rst_s      =   data_sync[1];


endmodule // omsp_sync_reset

