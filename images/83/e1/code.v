module fsm_module1 (
	input clk,
	input x,
	output t);reg [2:0] state = 0;

always @(posedge clk) begin
	state <= { state[2] & x & state[1], state[1] | x | state[0], ~(state[0] | x | state[2]) };
end

assign t = ~(state[2] & state[1] & state[0]);

endmodule