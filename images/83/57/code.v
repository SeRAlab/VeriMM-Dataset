module comb_module2 (
	input clk,
	input b,
	output z);reg [1:0] state = 0;

	always @(posedge clk) begin
		state <= { ~(state[1] & b), ~(state[0] | ~b) };
	end

	assign z = state[1] | state[0];

endmodule