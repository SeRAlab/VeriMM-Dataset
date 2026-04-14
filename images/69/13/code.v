module fsm_module5 (
	input clk,
	input e,
	output t);
	
reg [2:0] state = 0;

	always @(posedge clk) begin
		state <= { state[2] & e, ~(state[1] & ~e), ~(state[0] ^ e) };
	end
	
	assign t = ~(state[2] | state[1] | state[0]);
	
endmodule