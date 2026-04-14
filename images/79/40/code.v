module fsm_module3 (
	input clk,
	input b,
	output u);reg [2:0] state = 0;
	
	always @(posedge clk) begin
		state <= { state[2] ^ b, ~state[1] & b, ~state[0] | b };		
	end
	
	assign u = |state;
	
endmodule