module shift_register(
	input clk,
	input reset,
	input serial_in,
	output reg [15:0] q);always @(posedge clk)
	if (reset)
		q <= 16'b0;
	else
		q <= {q[14:0], serial_in};

endmodule