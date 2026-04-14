module counter_module (
	input clk,
	input enable, 
	output reg [3:0] count);always @(posedge clk)
		if (enable)
			count <= count + 1;
		else
			count <= count;

endmodule