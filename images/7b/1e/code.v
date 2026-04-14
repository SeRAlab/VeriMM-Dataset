module shift_register(
	input clk,
	input reset_n,
	input serial_in,
	output reg [5:0] q);always @(posedge clk or negedge reset_n)
	if (!reset_n)
		q <= 6'b0;
	else
		q <= {q[4:0], serial_in};

endmodule