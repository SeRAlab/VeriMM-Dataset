module counter_with_load (
	input clk,
	input load,
	input [8:0] data_in,
	output reg [8:0] count);

always @(posedge clk)
	if (load)
		count <= data_in;
	else
		count <= count + 1;

endmodule