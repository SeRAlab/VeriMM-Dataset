module down_counter (
	input clk,
	input resetn,
	output reg [3:0] count);

always @(negedge clk or negedge resetn)
	if (!resetn)
		count <= 4'b1111;
	else
		count <= count - 1;

endmodule