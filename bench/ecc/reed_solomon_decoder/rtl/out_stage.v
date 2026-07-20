module out_stage
/////  generate output bytes from pipeling memories
(

input clk, // input clock planned to be 56 Mhz
input reset, // active high asynchronous reset

// active high flag for one clock to indicate that the block should work
input DONE, 

output reg RE,  /// RE for input memories 

output reg [7:0] RdAdd,

input [7:0] In_byte,
//////////////////////////////////////
output reg [7:0] Out_byte,
output reg CEO,
output reg Valid_out,
//////////////////////////////////////
output reg out_done

);

reg CE;
reg [2:0] cnt8;


reg state;  //// 0 or 1

reg F;  /// flag to control translation from state 0 to state1

////// CE generation///////////
always@(posedge clk or posedge reset)
begin
	if(reset)
		begin
			CE<=0;
			cnt8<=0;
			CEO<=0;
		end
	else
		begin
			cnt8<=cnt8+1;
			CEO <= CE;
			
			if(&cnt8)
				CE<=1;
			else
				CE<=0;
		end
end
//////////////////////////////////////////////////////////
always@(posedge clk or posedge reset)
begin
	if(reset)
		begin
			RE<=0;
			RdAdd<=0;
			out_done<=0;
			state<=0;
			Valid_out<=0;
			Out_byte<=0;
			F<=0;
		end
	else
		begin
			case(state)
			////////////////////////////////////////////////
			1:begin  // operation is running
				if (CE)
						begin
							if(RdAdd == 187)
								begin
									state<=0;
									out_done<=1;
								end
							else	
								RdAdd<=RdAdd+1;
								
								Out_byte<=In_byte;
								Valid_out<=1;
						end	
			end
			///////////////////////////////////////////////
			default:begin    /// idle state
				if(CE)
					Valid_out<=0;
				
				
				out_done<=0;
				
				if(DONE)
					begin
						F<=1;
						RE<=~RE;
						RdAdd<=0;
					end
				
				if(F && CE)
					begin
						state<=1;
						F<=0;
					end
			end
			/////////////////////////////////////////////////////////////////////
			endcase
		end
end

endmodule 
