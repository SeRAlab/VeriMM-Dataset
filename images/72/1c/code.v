module fsm_module19 (
	input clk,
	input j,
	output p);
	
	reg [2:0] state = 0;

	always @(posedge clk) begin
		state <= { ~(state[2] & j), state[1] ^ ~j, ~(state[0] | j) };
	end
	
	assign p = &state;
	
endmodule