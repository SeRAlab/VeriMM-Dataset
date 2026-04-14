module fsm_module2 (
	input clk,
	input k,
	output r);reg [2:0] state = 0;

	always @(posedge clk) begin
		state <= { state[2] ^ k, ~(~state[1] & k), state[0] | k };		
	end
	
	assign r = ~(state[2] & state[1] & state[0]);
	
endmodule