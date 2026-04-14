module fsm_module7 (
	input clk,
	input p,
	output w);reg [2:0] state = 0;

	always @(posedge clk) begin
		state <= { state[2] ^ p, ~(~state[1] & p), state[0] | p };		
	end
	
	assign w = &state;
	
endmodule