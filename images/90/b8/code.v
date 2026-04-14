module fsm_module1 (
	input clk,
	input f,
	output s);reg [1:0] state = 0;
	
	always @(posedge clk) begin
		state <= { ~(state[1] & f), ~(state[0] | f) };		
	end
	
	assign s = state[1] & state[0];
	
endmodule