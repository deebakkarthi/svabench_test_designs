module transport_in2out
///  transport input block from input pipeling memories to output pipeling memories
(

input clk, // input clock planned to be 56 Mhz
input reset, // active high asynchronous reset

// active high flag for one clock to indicate that the block should work
input S_Ready, 

output reg RE,WE,  /// RE for input memories , WE for output memories 

output reg [7:0] RdAdd,WrAdd,

output reg Wr_done

);


reg cnt;

reg state;  //// 0 or 1



always@(posedge clk or posedge reset)
begin
	if(reset)
		begin
			WE<=0;
			RE<=0;
			RdAdd<=0;
			WrAdd<=0;
			Wr_done<=0;
			state<=0;
			cnt<=0;
		end
	else
		begin
			case(state)
			////////////////////////////////////
			1:begin    //// operation is runing
				cnt<=~cnt;
				
				if(cnt)
					begin
						WrAdd<=WrAdd+1;
						if(WrAdd == 186)
							begin
								state<=0;
								Wr_done<=1;
							end
					end
				else
					begin
						RdAdd<=RdAdd-1;
					end
			end
			///////////////////////////////////////
			default:begin    //// idle state
				Wr_done<=0;
				if(S_Ready)
					begin
						state<=1;
						RE<=~RE;
						WE<=~WE;
						RdAdd<= 204;
						WrAdd<= 255;
						cnt<=0;
					end
			end
			///////////////////////////////////
			endcase
		end
end

endmodule 
