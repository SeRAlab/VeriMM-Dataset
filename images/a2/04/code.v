module shift_register (
	input clk,
	input reset,
	input shift,
	input load,
	input [3:0] parallel_in,
	output [3:0] q
);reg [3:0] q_reg;

always @(posedge clk or posedge reset) begin
	if (reset)
		q_reg <= 4'b0000;
	else if (load)
		q_reg <= parallel_in;
	else if (shift)
		q_reg <= {q_reg[2:0], 1'b0};
end

assign q = q_reg;

endmodule