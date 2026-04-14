module comb_module5 (
	input clk,
	input h,
	output r);reg [1:0] state = 0;

	always @(posedge clk) begin
		state <= { state[1] & h, state[0] | ~h };
	end

	assign r = state[1] ^ state[0];

endmodule