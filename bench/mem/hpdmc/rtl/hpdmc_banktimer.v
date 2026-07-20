module hpdmc_banktimer(
	input sys_clk,
	input sdram_rst,
	
	input tim_cas,
	input [1:0] tim_wr,
	
	input read,
	input write,
	output reg precharge_safe
);

reg [2:0] counter;
always @(posedge sys_clk) begin
	if(sdram_rst) begin
		counter <= 3'd0;
		precharge_safe <= 1'b1;
	end else begin
		if(read) begin
			/* see p.26 of datasheet :
			 * "A Read burst may be followed by, or truncated with, a Precharge command
			 * to the same bank. The Precharge command should be issued x cycles after
			 * the Read command, where x equals the number of desired data element
			 * pairs"
			 */
			counter <= 3'd4;
			precharge_safe <= 1'b0;
		end else if(write) begin
			counter <= {1'b1, tim_wr};
			precharge_safe <= 1'b0;
		end else begin
			if(counter == 3'b1)
				precharge_safe <= 1'b1;
			if(~precharge_safe)
				counter <= counter - 3'b1;
		end
	end
end

endmodule
