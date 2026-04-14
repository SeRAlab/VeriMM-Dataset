module fsm_module8 (
	input clk,
	input h,
	output q);
	
reg [2:0] state = 0;

	always @(posedge clk) begin
		state <= { ~(state[2] ^ h), state[1] & ~h, ~(state[0] & h) };
	end
	
	assign q = ~(state[2] | state[1] | state[0]);
	
endmodule