module fsm_module6 (
	input clk,
	input f,
	output s);
	
reg [2:0] state = 0;

	always @(posedge clk) begin
		state <= { state[2] | ~f, state[1] & f, ~(state[0] ^ f) };
	end
	
	assign s = state[2] | state[1] | state[0];
	
endmodule