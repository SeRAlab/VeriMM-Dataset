module fsm_module4 (
	input clk,
	input c,
	output t);reg [2:0] state = 0;
	
	always @(posedge clk) begin
		state <= { state[2] ^ c, ~state[1] & c, ~state[0] | c };		
	end
	
	assign t = ~&state;
	
endmodule