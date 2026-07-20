//synopsys translate_off
`include "timescale.v"
//synopsys translate_on

module vga_tgen(
	clk, clk_ena, rst,
	Thsync, Thgdel, Thgate, Thlen, Tvsync, Tvgdel, Tvgate, Tvlen,
	eol, eof, gate, hsync, vsync, csync, blank
	);

	// inputs & outputs
	input clk;
	input clk_ena;
	input rst;

	// horizontal timing settings inputs
	input [ 7:0] Thsync; // horizontal sync pule width (in pixels)
	input [ 7:0] Thgdel; // horizontal gate delay
	input [15:0] Thgate; // horizontal gate (number of visible pixels per line)
	input [15:0] Thlen;  // horizontal length (number of pixels per line)

	// vertical timing settings inputs
	input [ 7:0] Tvsync; // vertical sync pule width (in pixels)
	input [ 7:0] Tvgdel; // vertical gate delay
	input [15:0] Tvgate; // vertical gate (number of visible pixels per line)
	input [15:0] Tvlen;  // vertical length (number of pixels per line)

	// outputs
	output eol;  // end of line
	output eof;  // end of frame
	output gate; // vertical AND horizontal gate (logical AND function)

	output hsync; // horizontal sync pulse
	output vsync; // vertical sync pulse
	output csync; // composite sync
	output blank; // blank signal

	//
	// variable declarations
	//
	wire Hgate, Vgate;
	wire Hdone;

	//
	// module body
	//

	// hookup horizontal timing generator
	vga_vtim hor_gen(
		.clk(clk),
		.ena(clk_ena),
		.rst(rst),
		.Tsync(Thsync),
		.Tgdel(Thgdel),
		.Tgate(Thgate),
		.Tlen(Thlen),
		.Sync(hsync),
		.Gate(Hgate),
		.Done(Hdone)
	);


	// hookup vertical timing generator
	wire vclk_ena = Hdone & clk_ena;

	vga_vtim ver_gen(
		.clk(clk),
		.ena(vclk_ena),
		.rst(rst),
		.Tsync(Tvsync),
		.Tgdel(Tvgdel),
		.Tgate(Tvgate),
		.Tlen(Tvlen),
		.Sync(vsync),
		.Gate(Vgate),
		.Done(eof)
	);

	// assign outputs
	assign eol  = Hdone;
	assign gate = Hgate & Vgate;
	assign csync = hsync | vsync;
	assign blank = ~gate;
endmodule
