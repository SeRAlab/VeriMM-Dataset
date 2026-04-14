module fsm_module6 (
	input clk,
	input i,
	output t);reg [2:0] state = 0;

	always @(posedge clk) begin
		state <= { ~(state[2] | i), ~(state[1] & ~i), state[0] ^ ~i };
	end

	assign t = state[2] ^ state[1] ^ state[0];

endmodule