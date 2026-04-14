module fsm_module2 (
	input clk,
	input y,
	output r);reg [2:0] state = 0;

always @(posedge clk) begin
	state <= { ~(state[2] & y), ~(state[1] | y), state[0] ^ y };
end

assign r = state[2] & state[1] & state[0];

endmodule