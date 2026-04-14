module top_module(clk, rst, level, tick);input clk, rst, level;
	output tick;
	
	reg [1:0] state, nextState;
	
	parameter [1:0] zero = 2'b00, edg = 2'b01, one = 2'b10;
	
	always @(level or state)
		case (state)
			zero: if (level) nextState = edg;
				  else nextState = zero;
			edg: if (level) nextState = one;
				  else nextState = zero;
			one: if (level) nextState = one;
				  else nextState = zero;
		endcase
		
	always @(posedge clk or negedge rst) begin
		if(rst)
			state <= zero;
		else
			state <= nextState;
	end
	assign tick = (state == edg);
endmodule