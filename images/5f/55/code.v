module sync_binary_counter_with_load(
	input clk,
	input load,
	input [4:0] data,
	output reg [4:0] q);

initial
		q = 5'b00000;
		
always @(posedge clk)
	if (load)
		q <= data;
	else
		q <= q + 1;

endmodule