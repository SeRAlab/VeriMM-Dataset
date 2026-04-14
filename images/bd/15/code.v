module counter (
	input clk,
	input reset,
	output reg [5:0] count);

always @(posedge clk)
	if (reset)
		count <= 6'b111111;
	else
		count <= count + 1;

endmodule