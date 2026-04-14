module fsm_module6 (
	input clk,
	input l,
	output v);reg [2:0] state = 0;

	always @(posedge clk) begin
		state <= { state[2] ~^ l, ~(~state[1] & l), state[0] | l };		
	end
	
	assign v = |state;
	
endmodule