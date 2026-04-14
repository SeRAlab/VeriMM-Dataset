module up_down_counter (
	input clk,
	input resetn,
	input up_down,
	output reg [11:0] count);

always @(posedge clk)
	if (!resetn)
		count <= 12'b000000000000;
	else if (up_down)
		count <= count + 1;
	else
		count <= count - 1;

endmodule