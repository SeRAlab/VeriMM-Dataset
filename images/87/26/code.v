module top_module (
	input clk,
	input rst,
	input in, 
	output reg out);reg [1:0] state, next_state;

parameter S0 = 2'b00,
          S1 = 2'b01,
          S2 = 2'b10;

always @(posedge clk or posedge rst)
	if (rst)
		state <= S0;
	else
		state <= next_state;

always @(*)
	case (state)
		S0: if (in) next_state = S1; else next_state = S0;
		S1: if (in) next_state = S1; else next_state = S2;
		S2: if (in) next_state = S1; else next_state = S0;
		default: next_state = S0;
	endcase

always @(posedge clk or posedge rst)
	if (rst)
		out <= 0;
	else
		out <= (state == S2) && in;

endmodule