module fsm_module9 (
	input clk,
	input g,
	output h);reg [2:0] state = 0;

always @(posedge clk) begin
	state <= { state[2] ^ g, state[1] | g, ~(state[0] | g) };
end

assign h = state[2] & state[1] & state[0];

endmodule