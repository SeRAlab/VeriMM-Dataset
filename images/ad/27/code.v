module multi_gate_circuit (
	input clk,
	input w,
	output z);

reg [2:0] state = 0;

	always @(posedge clk) begin
		state <= { state[2] | ~w, ~(state[1] | w), state[0] & ~w };
	end
	
	assign z = ~(state[2] & state[1] & state[0]);

endmodule