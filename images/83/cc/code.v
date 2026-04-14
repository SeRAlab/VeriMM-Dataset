module shift_register(
	input clk,
	output reg [3:0] q);always @(posedge clk)
	q <= {q[2:0], 1'b0};

endmodule