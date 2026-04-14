module fsm_module5 (
	input clk,
	input d,
	output s);reg [2:0] state = 0;
	
	always @(posedge clk) begin
		state <= { state[2] ^ d, ~state[1] & d, ~state[0] | d };		
	end
	
	assign s = ^state;
	
endmodule