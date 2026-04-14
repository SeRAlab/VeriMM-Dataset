module fsm_module3 (
	input clk,
	input z,
	output w);reg [2:0] state = 0;

always @(posedge clk) begin
	state <= { state[2] | z | state[1], state[1] ^ z ^ state[0], state[0] & z & state[2] };
end

assign w = ~(state[2] | state[1] | state[0]);

endmodule