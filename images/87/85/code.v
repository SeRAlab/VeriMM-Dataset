module processing_unit (
	input clk,
	input p,
	output q);

reg [2:0] state = 0;

	always @(posedge clk) begin
		state <= { state[2] & p, state[1] | p, ~(state[0] ^ p) };
	end
	
	assign q = state[2] ^ state[1] ^ state[0];

endmodule