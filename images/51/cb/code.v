module fsm_module9 (
	input clk,
	input h,
	output w);reg [1:0] state = 0;
	
	always @(posedge clk) begin
		state <= { (state[1] | h), (state[0] ^ h) };		
	end
	
	assign w = ~(state[1] | state[0]);
	
endmodule