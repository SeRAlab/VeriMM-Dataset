module counter (
	input clk,
	input resetn,
	input en,
	output reg [3:0] count);

always @(posedge clk or negedge resetn)
	if (!resetn)
		count <= 4'b0000;
	else if (en)
		count <= count + 1;

endmodule