module complex_circuit (
	input clk,
	input h,
	output r);

reg [2:0] state = 0;

	always @(posedge clk) begin
		state <= { ~(state[2] | h), state[1] ^ h, ~(state[0] & h) };
	end
	
	assign r = ~(state[2] & state[1] & state[0]);

endmodule