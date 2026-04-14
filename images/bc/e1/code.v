module fsm_module9 (
	input clk,
	input i,
	output p);
	
reg [2:0] state = 0;

	always @(posedge clk) begin
		state <= { state[2] ^ i, ~(state[1] | ~i), state[0] | i };
	end
	
	assign p = state[2] & state[1] & state[0];
	
endmodule