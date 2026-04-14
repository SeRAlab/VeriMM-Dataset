module parallel_load_shift_register(
	input clk,
	input load,
	input [7:0] d,
	output reg [7:0] q);
	
always @(posedge clk)
	if (load)
		q <= d;
	else
		q <= {1'b0, q[7:1]};

endmodule