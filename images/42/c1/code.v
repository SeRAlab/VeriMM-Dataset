module loadable_counter (
	input clk,
	input load,
	input [7:0] load_val,
	output reg [7:0] count);

always @(posedge clk)
	if (load)
		count <= load_val;
	else
		count <= count + 1;

endmodule