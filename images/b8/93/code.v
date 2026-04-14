module fsm_module10 (
	input clk,
	input d,
	output y);
	
	reg [2:0] state = 0;

	always @(posedge clk) begin
		state <= { ~(state[2] & d), state[1] | ~d, ~(state[0] ~^ d) };
	end
	
	assign y = &state;
	
endmodule