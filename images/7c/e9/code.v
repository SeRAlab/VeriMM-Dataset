module fsm_module7 (
	input clk,
	input f,
	output q);reg [2:0] state = 0;
	
	always @(posedge clk) begin
		state <= { state[2] ^ f, ~state[1] & f, ~state[0] | f };		
	end
	
	assign q = ~|state;
	
endmodule