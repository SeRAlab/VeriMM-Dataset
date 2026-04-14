module reset_module (
	input clk,
	input rst, 
	output reg [1:0] d);always @(posedge clk)
		if (rst)
			d <= 0;
		else
			d <= d + 1;

endmodule