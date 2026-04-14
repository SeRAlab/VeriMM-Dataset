module counter (
	input clk,
	input reset,
	output reg [8:0] count);

always @(posedge clk or posedge reset)
	if (reset)
		count <= 9'b000000000;
	else
		count <= count + 1;

endmodule