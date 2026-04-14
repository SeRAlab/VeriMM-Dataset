module custom_circuit (
	input clk,
	input g,
	output t);

reg [2:0] state = 0;

	always @(posedge clk) begin
		state <= { ~g, ~(state[1] & g), ~(state[0] | g) };
	end
	
	assign t = state[2] & state[1] & state[0];

endmodule