module fsm_module10 (
	input clk,
	input i,
	output n);reg [2:0] state = 0;
	
	always @(posedge clk) begin
		state <= { state[2] ^ i, ~state[1] & i, ~state[0] | i };		
	end
	
	assign n = ~&state;
	
endmodule