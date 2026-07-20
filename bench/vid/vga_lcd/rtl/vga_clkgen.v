//synopsys translate_off
`include "timescale.v"
//synopsys translate_on

`include "vga_defines.v"

module vga_clkgen (
	pclk_i, rst_i, pclk_o, dvi_pclk_p_o, dvi_pclk_m_o, pclk_ena_o
);

	// inputs & outputs

	input  pclk_i;       // pixel clock in
	input  rst_i;        // reset input

	output pclk_o;       // pixel clock out

	output dvi_pclk_p_o; // dvi cpclk+ output
	output dvi_pclk_m_o; // dvi cpclk- output

	output pclk_ena_o;   // pixel clock enable output

	//
	// variable declarations
	//
	reg dvi_pclk_p_o;
	reg dvi_pclk_m_o;

	//////////////////////////////////
	//
	// module body
	//

	// These should be registers in or near IO buffers
	always @(posedge pclk_i)
	  if (rst_i) begin
	    dvi_pclk_p_o <= #1 1'b0;
	    dvi_pclk_m_o <= #1 1'b0;
	  end else begin
	    dvi_pclk_p_o <= #1 ~dvi_pclk_p_o;
	    dvi_pclk_m_o <= #1 dvi_pclk_p_o;
	  end


`ifdef VGA_12BIT_DVI
	// DVI circuit
	// pixel clock is half of the input pixel clock

	reg pclk_o, pclk_ena_o;

	always @(posedge pclk_i)
	  if (rst_i)
	    pclk_o <= #1 1'b0;
	  else
	    pclk_o <= #1 ~pclk_o;

	always @(posedge pclk_i)
	  if (rst_i)
	    pclk_ena_o <= #1 1'b1;
	  else
	    pclk_ena_o <= #1 ~pclk_ena_o;

`else
	// No DVI circuit
	// Simply reroute the pixel clock input

	assign pclk_o     = pclk_i;
	assign pclk_ena_o = 1'b1;
`endif

endmodule

