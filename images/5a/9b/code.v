module loadable_counter(
	input clk,
	input reset_n,
	input load,
	input [11:0] load_value,
	output reg [11:0] q);always @(posedge clk or negedge reset_n)
	if (!reset_n)
		q <= 12'b0;
	else if (load)
		q <= load_value;
	else
		q <= q + 1;

endmodule