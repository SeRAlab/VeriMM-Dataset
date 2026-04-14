module counter (
	input clk,
	input resetn,
	output reg [4:0] count);

always @(negedge clk or negedge resetn)
	if (!resetn)
		count <= 5'b11111;
	else
		count <= count - 1;

endmodule