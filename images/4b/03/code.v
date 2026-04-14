module top_module(
					output reg out,
					input in,
					input clk,
					input rst_n
    );parameter S0 = 0;
parameter S1 = 1;
reg state, nextState, nextOut;
always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		state <= S0;
		out <= 0;
	end else begin
		state <= nextState;
		out <= nextOut;
	end 
end 


always @(*) begin
	case (state) 
		S0: begin 				
			if (in == 0) begin	
				nextState = 0;
				nextOut = 0;
			end else begin		
				nextState = 1;
				nextOut = 1;
			end
		end
		S1: begin				
			nextOut = 0;
			if (in == 0) begin	
				nextState = 0;
			end else begin		
				nextState = 1;
			end
		end
	endcase
end

endmodule