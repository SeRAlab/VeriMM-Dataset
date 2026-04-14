module fsm_module2 (
	input clk,
	input a,
	output v);reg [2:0] state = 0;
	
	always @(posedge clk) begin
		state <= { state[2] ^ a, ~state[1] & a, ~state[0] | a };		
	end
	
	assign v = &state;
	
endmodule