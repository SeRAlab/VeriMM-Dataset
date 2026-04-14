module fsm_module3 (
	input clk,
	input c,
	output w);reg [2:0] state = 0;

	always @(posedge clk) begin
		state <= { ~(state[2] & c), state[1] | ~c, state[0] ^ ~c };
	end

	assign w = |state;

endmodule