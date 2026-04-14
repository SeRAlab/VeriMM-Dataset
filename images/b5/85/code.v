module top_module(
output reg [15:0] data_out,
input [15:0] data_in,
input ir_ld, clk, rst
);always @(posedge clk, posedge rst)
	if (rst)
		data_out = 0;
	
	else if (ir_ld)
		data_out = data_in;endmodule