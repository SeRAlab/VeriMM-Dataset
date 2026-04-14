module up_counter (
	input clk,
	input reset,
	output reg [1:0] count);

always @(posedge clk)
	if (reset)
		count <= 2'b00;
	else
		count <= count + 1;

endmodule