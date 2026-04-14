module top_module(
				input in,
				input clk,
				input rst_n,
				output reg out
			 );parameter S0 = 0;
parameter S1 = 1;
reg state, nextState;
reg tmp_out;
always @(posedge clk or negedge rst_n) begin
	if (~rst_n) begin
		state <= S0;
	end else begin
		state <= nextState;
	end 
end 


always @(*) begin
	case (state) 
		S0: begin 				
			if (in == 0) begin	
				nextState <= 0;
			end else begin		
				nextState <= 1;
			end
		end
		S1: begin				
			if (in == 0) begin	
				nextState <= 0;
			end else begin		
				nextState <= 1;
			end
		end
	endcase
end


always @(*) begin
	case (state)
		S0: begin 				
			if (in == 0) begin	
				tmp_out <= 0;
			end else begin		
				tmp_out <= 1;
			end
		end
		S1: begin				
			tmp_out <= 0;
		end
	endcase
end

always @(posedge clk or negedge rst_n) begin
	if(~rst_n) begin
		out <= 0;
	end else begin
		out <= tmp_out;
	end
end
endmodule