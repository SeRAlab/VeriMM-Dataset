module load_reg (
	input clk,
	input rst,
	input load,
	input [2:0] d,
	output reg [2:0] q);always @(posedge clk or posedge rst)
	if (rst)
		q <= 0;
	else if (load)
		q <= d;
		
endmodule