module comb_module3 (
	input clk,
	input d,
	output x);reg [2:0] state = 0;

	always @(posedge clk) begin
		state <= { ~(state[2] | d), state[1] & ~d, state[0] ^ ~d };
	end

	assign x = ~(state[2] & state[1] & state[0]);

endmodule