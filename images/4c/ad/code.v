module fsm_module7 (
	input clk,
	input d,
	output u);reg [3:0] state = 0;
	
	always @(posedge clk) begin
		state <= { (state[3] | d), state[2] ^ d, ~(state[1] & d), ~(state[0] | d) };		
	end
	
	assign u = ~(state[3] & state[2] & state[1] & state[0]);
	
endmodule