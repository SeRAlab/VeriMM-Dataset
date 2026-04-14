module digital_logic (
	input clk,
	input k,
	output l);

reg [2:0] state = 0;

	always @(posedge clk) begin
		state <= { state[2] ^ k, ~(state[1] | k), ~(state[0] & k) };
	end
	
	assign l = state[2] | state[1] | state[0];

endmodule