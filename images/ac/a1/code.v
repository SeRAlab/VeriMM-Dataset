module up_down_counter (
	input clk,
	input reset,
	input dir,
	output reg [3:0] count);

always @(posedge clk)
	if (reset)
		count <= 4'b0000;
	else if (dir)
		count <= count + 1;
	else
		count <= count - 1;

endmodule