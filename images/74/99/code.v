module count_down (
	input clk,
	input rst,
	input en,
	output reg [2:0] q);always @(posedge clk or posedge rst)
	if (rst)
		q <= 3;
	else if (en)
		q <= q - 1'b1;
		
endmodule