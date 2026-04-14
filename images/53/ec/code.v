module fsm_module9 (
	input clk,
	input h,
	output o);reg [2:0] state = 0;
	
	always @(posedge clk) begin
		state <= { state[2] ^ h, ~state[1] & h, ~state[0] | h };		
	end
	
	assign o = |state;
	
endmodule