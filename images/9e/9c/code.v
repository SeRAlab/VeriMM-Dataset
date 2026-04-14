module sync_counter_with_clear_and_load(
	input clk,
	input clear,
	input load,
	input [7:0] data,
	output reg [7:0] q);

initial
		q = 8'b00000000;
		
always @(posedge clk or posedge clear)
	if (clear)
		q <= 8'b00000000;
	else if (load)
		q <= data;
	else
		q <= q + 1;

endmodule