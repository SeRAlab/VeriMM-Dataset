module logic_circuit (
	input clk,
	input m,
	output n);

reg [2:0] state = 0;

	always @(posedge clk) begin
		state <= { state[2] ^ m, ~(state[1] & m), ~(state[0] | m) };
	end
	
	assign n = ~(state[2] | state[1] | state[0]);

endmodule