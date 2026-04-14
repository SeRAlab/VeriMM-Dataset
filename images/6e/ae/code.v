module gate_network (
	input clk,
	input u,
	output v);

reg [2:0] state = 0;

	always @(posedge clk) begin
		state <= { ~(state[2] & u), ~(state[1] | u), state[0] ^ ~u };
	end
	
	assign v = state[2] & state[1] & state[0];

endmodule