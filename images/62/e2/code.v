module fsm_module6 (
	input clk,
	input c,
	output q);reg [2:0] state = 0;

always @(posedge clk) begin
	state <= { state[2] | c, state[1] ^ c, state[0] & c };
end

assign q = ~(state[2] | state[1] | state[0]);

endmodule