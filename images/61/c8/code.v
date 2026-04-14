module counter (
	input clk,
	input resetn,
	output reg [10:0] count);

always @(posedge clk)
	if (!resetn)
		count <= 11'b11111111111;
	else
		count <= count - 1;

endmodule