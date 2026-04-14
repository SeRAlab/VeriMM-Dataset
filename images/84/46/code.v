module loadable_counter(
	input clk,
	input load,
	input [6:0] load_value,
	output reg [6:0] q);

always @(posedge clk)
	if (load)
		q <= load_value;
	else
		q <= q + 1;
endmodule