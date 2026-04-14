module fsm_module10 (
	input clk,
	input i,
	output x);reg [3:0] state = 0;
	
	always @(posedge clk) begin
		state <= { (state[3] & i), (state[2] | i), (state[1] ^ i), ~(state[0] & i) };		
	end
	
	assign x = state[3] ^ state[2] ^ state[1] ^ state[0];
	
endmodule