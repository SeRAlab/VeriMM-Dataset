module comb_module4 (
	input clk,
	input f,
	output q);reg [1:0] state = 0;

	always @(posedge clk) begin
		state <= { state[1] ^ f, ~(state[0] & ~f) };
	end

	assign q = ~(state[1] | state[0]);

endmodule