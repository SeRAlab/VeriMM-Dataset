module fsm_module10 (
	input clk,
	input r,
	output y);reg [2:0] state = 0;

	always @(posedge clk) begin
		state <= { state[2] ^ r, ~(~state[1] & r), ~(state[0] | r) };		
	end
	
	assign y = ~(state[2] & state[1] & state[0]);
	
endmodule