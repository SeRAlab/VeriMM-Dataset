module shift_register(
	input clk,
	input reset_n,
	input shift,
	input [7:0] data_in,
	output reg [7:0] q);

always @(posedge clk)
	if (!reset_n)
		q <= 0;
	else if (shift)
		q <= {q[6:0], data_in[7]};

endmodule