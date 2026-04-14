module fsm_module5 (
	input clk,
	input b,
	output v);reg [2:0] state = 0;

always @(posedge clk) begin
	state <= { ~(state[2] | b), ~(state[1] & b), state[0] ^ b };
end

assign v = state[2] | state[1] | state[0];

endmodule