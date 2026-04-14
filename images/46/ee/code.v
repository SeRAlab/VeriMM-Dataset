module top_module(output reg Y, input X, clk, rst);reg [1:0] state, nextstate;
parameter S0 = 2'b00, S1 = 2'b01, S2 = 2'b10, S3 = 2'b11;

always @ (posedge clk, negedge rst)
begin
	if(!rst)
		state <= S0;
	else
		state <= nextstate;
end

always @ (state, X)
begin
	case(state)
		S0 : if(X) nextstate <= S1; else nextstate <= S0;
		S1 : if(X) nextstate <= S3; else nextstate <= S0;
		S2 : if(X) nextstate <= S2; else nextstate <= S0;
		S3 : if(X) nextstate <= S2; else nextstate <= S0;
	endcase
end

always @ (state, X)
begin
	case(state)
		S0 : Y <= 1'b0;
		S1, S2, S3 : Y <= !X;
	endcase
end

endmodule