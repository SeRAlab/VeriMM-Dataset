module fsm_module5 (
	input clk,
	input n,
	output u);reg [2:0] state = 0;

	always @(posedge clk) begin
		state <= { state[2] ~^ n, ~state[1] & n, ~(state[0] | n) };		
	end
	
	assign u = &state;
	
endmodule