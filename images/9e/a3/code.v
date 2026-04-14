module shift_register(
	input clk,
	input reset,
	input left,
	input right,
	input [7:0] d_in,
	output reg [7:0] q);always @(posedge clk)
	if (reset)
		q <= 8'b00000000;
	else if (left)
		q <= {q[6:0], d_in[0]};
	else if (right)
		q <= {d_in[7], q[7:1]};

endmodule