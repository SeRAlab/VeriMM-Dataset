module down_counter (
	input clk,
	input reset,
	output reg [6:0] count);

always @(posedge clk)
	if (reset)
		count <= 7'b1111111;
	else
		count <= count - 1;

endmodule