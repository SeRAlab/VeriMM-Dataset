module signal_processor (
	input clk,
	input x,
	output y);

reg [2:0] state = 0;

	always @(posedge clk) begin
		state <= { ~(state[2] | x), state[1] | x, state[0] & x };
	end
	
	assign y = state[2] | state[1] | state[0];

endmodule