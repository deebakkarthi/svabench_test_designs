//synopsys translate_off
`include "timescale.v"
//synopsys translate_on

module vga_cur_cregs (
	clk_i, rst_i, arst_i,
	hsel_i, hadr_i, hwe_i, hdat_i, hdat_o, hack_o,
	cadr_i, cdat_o
	);

	//
	// inputs & outputs
	//

	// wishbone signals
	input         clk_i;         // master clock input
	input         rst_i;         // synchronous active high reset
	input         arst_i;        // asynchronous active low reset

	// host interface
	input         hsel_i;        // host select input
	input  [ 2:0] hadr_i;        // host address input
	input         hwe_i;         // host write enable input
	input  [31:0] hdat_i;        // host data in
	output [31:0] hdat_o;        // host data out
	output        hack_o;        // host acknowledge out

	reg [31:0] hdat_o;
	reg        hack_o;
	
	// cursor processor interface
	input  [ 3:0] cadr_i;        // cursor address in
	output [15:0] cdat_o;        // cursor data out

	reg [15:0] cdat_o;


	//
	// variable declarations
	//
	reg  [31:0] cregs [7:0];  // color registers
	wire [31:0] temp_cdat;

	//
	// module body
	//


	////////////////////////////
	// generate host interface

	// write section
	always@(posedge clk_i)
		if (hsel_i & hwe_i)
			cregs[hadr_i] <= #1 hdat_i;

	// read section
	always@(posedge clk_i)
		hdat_o <= #1 cregs[hadr_i];

	// acknowledge section
	always@(posedge clk_i)
		hack_o <= #1 hsel_i & !hack_o;


	//////////////////////////////
	// generate cursor interface

	// read section
	assign temp_cdat = cregs[cadr_i[3:1]];

	always@(posedge clk_i)
		cdat_o <= #1 cadr_i[0] ? temp_cdat[31:16] : temp_cdat[15:0];

endmodule

