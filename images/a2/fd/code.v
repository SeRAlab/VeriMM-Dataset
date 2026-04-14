module up_counter (
	input clk,
	input resetn,
	input en,
	output reg [7:0] count);

always @(posedge clk)
	if (!resetn)
		count <= 8'b00000000;
	else if (en)
		count <= count + 1;

endmodule