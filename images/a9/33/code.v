module top_module(clk, ci, din, dout);input clk, ci; 
	input[5:0] din; 
	output reg dout; 
	
	parameter PLAY = 0, OVER = 1; 
	reg state, nextstate;
	
	
	always @ (posedge clk)
	begin
		if (ci) 
		begin
			state = OVER; 
		end
		else state = nextstate;
	end

	
	always @ (*)
	begin
	    
		dout = 0;
		case (state) 
			PLAY: begin
					if (!din) 
					begin
						nextstate = OVER;
						dout = 1;
					end
					else nextstate = PLAY;  
				  end
			OVER: begin
					if (!din) nextstate = OVER; 
					else nextstate = PLAY; 
				  end
			default: begin nextstate = OVER; dout = 1; end
		endcase 
	end
endmodule