module fsm_module1 (
	input clk,
	input a,
	output z);
	
reg [2:0] state = 0;

	always @(posedge clk) begin
		state <= { state[2] & ~a, state[1] | a, ~(state[0] ^ a) };
	end
	
	assign z = state[2] | state[1] | state[0];
	
endmodule