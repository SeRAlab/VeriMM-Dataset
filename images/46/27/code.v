module fsm_module5 (
	input clk,
	input c,
	output p);reg [1:0] state = 0;
	
	always @(posedge clk) begin
		state <= { (state[1] | c), (state[0] & c) };		
	end
	
	assign p = ~(state[1] & state[0]);
	
endmodule