module fsm_module12 (
	input clk,
	input b,
	output w);
	
	reg [2:0] state = 0;

	always @(posedge clk) begin
		state <= { ~(state[2] | b), state[1] | ~b, state[0] & b };
	end
	
	assign w = |state;
	
endmodule