module up_counter (
	input clk,
	input resetn,
	output reg [7:0] count);

always @(posedge clk)
	if (!resetn)
		count <= 8'b00000000;
	else
		count <= count + 1;

endmodule