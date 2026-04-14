module fsm_module15 (
	input clk,
	input f,
	output t);
	
	reg [2:0] state = 0;

	always @(posedge clk) begin
		state <= { state[2] ^ f, state[1] & ~f, ~(state[0] & f) };
	end
	
	assign t = ~(state[0] & state[1] & state[2]);
	
endmodule