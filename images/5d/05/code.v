module fsm_module4 (
	input clk,
	input e,
	output y);reg [1:0] state = 0;

	always @(posedge clk) begin
		state <= { state[1] | e, state[0] ^ ~e };
	end

	assign y = state[1] & state[0];

endmodule