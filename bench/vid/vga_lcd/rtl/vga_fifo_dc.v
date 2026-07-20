//synopsys translate_off
`include "timescale.v"
//synopsys translate_on


/*

  Dual clock FIFO.

  Uses gray codes to move from one clock domain to the other.

  Flags are synchronous to the related clock domain;
  - empty: synchronous to read_clock
  - full : synchronous to write_clock

  CLR is available in both clock-domains.
  Asserting any clr signal resets the entire FIFO.
  When crossing clock domains the clears are synchronized.
  Therefore one clock domain can enter or leave the reset state before the other.
*/

module vga_fifo_dc (rclk, wclk, rclr, wclr, wreq, d, rreq, q, empty, full);

	// parameters
	parameter AWIDTH = 7;  //128 entries
	parameter DWIDTH = 16; //16bit databus

	// inputs & outputs
	input rclk;             // read clock
	input wclk;             // write clock
	input rclr;             // active high synchronous clear, synchronous to read clock
	input wclr;             // active high synchronous clear, synchronous to write clock
	input wreq;             // write request
	input [DWIDTH -1:0] d;  // data input
	input rreq;             // read request
	output [DWIDTH -1:0] q; // data output

	output empty;           // FIFO is empty, synchronous to read clock
	reg empty;
	output full;            // FIFO is full, synchronous to write clock
	reg full;

	// variable declarations
	reg rrst, wrst, srclr, ssrclr, swclr, sswclr;
	reg [AWIDTH -1:0] rptr, wptr, rptr_gray, wptr_gray;

	//
	// module body
	//


	function [AWIDTH:1] bin2gray;
		input [AWIDTH:1] bin;
		integer n;
	begin
		for (n=1; n<AWIDTH; n=n+1)
			bin2gray[n] = bin[n+1] ^ bin[n];

		bin2gray[AWIDTH] = bin[AWIDTH];
	end
	endfunction

	function [AWIDTH:1] gray2bin;
		input [AWIDTH:1] gray;
	begin
		// same logic as bin2gray
		gray2bin = bin2gray(gray);
	end
	endfunction

	//
	// Pointers
	//

	// generate synchronized resets
	always @(posedge rclk)
	begin
	    swclr  <= #1 wclr;
	    sswclr <= #1 swclr;
	    rrst   <= #1 rclr | sswclr;
	end

	always @(posedge wclk)
	begin
	    srclr  <= #1 rclr;
	    ssrclr <= #1 srclr;
	    wrst   <= #1 wclr | ssrclr;
	end


	// read pointer
	always @(posedge rclk)
	  if (rrst) begin
	      rptr      <= #1 0;
	      rptr_gray <= #1 0;
	  end else if (rreq) begin
	      rptr      <= #1 rptr +1'h1;
	      rptr_gray <= #1 bin2gray(rptr +1'h1);
	  end

	// write pointer
	always @(posedge wclk)
	  if (wrst) begin
	      wptr      <= #1 0;
	      wptr_gray <= #1 0;
	  end else if (wreq) begin
	      wptr      <= #1 wptr +1'h1;
	      wptr_gray <= #1 bin2gray(wptr +1'h1);
	  end

	//
	// status flags
	//
	reg [AWIDTH-1:0] srptr_gray, ssrptr_gray;
	reg [AWIDTH-1:0] swptr_gray, sswptr_gray;

	// from one clock domain, to the other
	always @(posedge rclk)
	begin
	    swptr_gray  <= #1 wptr_gray;
	    sswptr_gray <= #1 swptr_gray;
	end

	always @(posedge wclk)
	begin
	    srptr_gray  <= #1 rptr_gray;
	    ssrptr_gray <= #1 srptr_gray;
	end

	// EMPTY
	// WC: wptr did not increase
	always @(posedge rclk)
	  if (rrst)
	    empty <= #1 1'b1;
	  else if (rreq)
	    empty <= #1 bin2gray(rptr +1'h1) == sswptr_gray;
	  else
	    empty <= #1 empty & (rptr_gray == sswptr_gray);


	// FULL
	// WC: rptr did not increase
	always @(posedge wclk)
	  if (wrst)
	    full <= #1 1'b0;
	  else if (wreq)
	    full <= #1 bin2gray(wptr +2'h2) == ssrptr_gray;
	  else
	    full <= #1 full & (bin2gray(wptr + 2'h1) == ssrptr_gray);


	// hookup generic dual ported memory
	generic_dpram #(AWIDTH, DWIDTH) fifo_dc_mem(
		.rclk(rclk),
		.rrst(1'b0),
		.rce(1'b1),
		.oe(1'b1),
		.raddr(rptr),
		.do(q),
		.wclk(wclk),
		.wrst(1'b0),
		.wce(1'b1),
		.we(wreq),
		.waddr(wptr),
		.di(d)
	);

endmodule
