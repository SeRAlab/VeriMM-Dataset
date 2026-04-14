module fsm_module6 (
	input clk,
	input e,
	output r);reg [2:0] state = 0;
	
	always @(posedge clk) begin
		state <= { state[2] ^ e, ~state[1] & e, ~state[0] | e };		
	end
	
	assign r = ~^state;
	
endmodule