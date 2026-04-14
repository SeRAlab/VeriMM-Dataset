module top_module(
				input in,
				input clk,
				input rst_n,
				output reg out
			 );reg [1:0]state, nextState;
reg nextOut;
parameter S0 = 0;
parameter S1 = 1;
parameter S2 = 2;
always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		out <= 0;
		state <= 0;
	end else begin
		state <= nextState;
		out <= nextOut;
	end 
end 

always @(state or in) begin
	case (state)
		S0: begin								
			if (in == 0) begin					
				nextState <= S0;
			end else begin						
				nextState <= S1;
			end
		end
		S1: begin								
			if (in == 0) begin					
				nextState <= S0;
			end else begin						
				nextState <= S2;
			end
		end
		S2: begin
			if (in == 0) begin					
				nextState <= S0;
			end else begin						
				nextState <= S2;
			end
		end
	endcase
end
always @(state or in) begin
	case (state)
		S0: begin								
			nextOut <= 0;
		end
		S1: begin								
			if (in == 0) begin					
				nextOut <= 1;
			end else begin						
				nextOut <= 0;
			end
		end
		S2: begin
			nextOut <= 1;
		end
	endcase
end

always @(posedge clk or negedge rst_n) begin
	if (~rst_n) begin
		out <= 0;
	end else begin
		out <= nextOut;
	end 
end 

endmodule