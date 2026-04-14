module fsm_module4 (
	input clk,
	input j,
	output t);reg [2:0] state = 0;

	always @(posedge clk) begin
		state <= { state[2] ^ j, ~state[1] & j, ~(state[0] & j) };		
	end
	
	assign t = state[2] ^ state[1] ^ state[0];
	
endmodule