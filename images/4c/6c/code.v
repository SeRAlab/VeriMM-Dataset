module shift_reg(
	input clk,
	input reset,
	input d,
	output reg [2:0] q);always @(posedge clk)
	if (reset)
		q <= 3'b000;
	else
		q <= {q[1:0], d};

endmodule