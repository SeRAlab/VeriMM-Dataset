module fsm_module18 (
	input clk,
	input i,
	output q);
	
	reg [2:0] state = 0;

	always @(posedge clk) begin
		state <= { state[2] & i, state[1] ^ ~i, state[0] | i };
	end
	
	assign q = ~(state[0] & state[1] & state[2]);
	
endmodule