module top_module (
	input clk,
	input enable, 
	output reg [2:0] count);always @(posedge clk)
		if (enable)
			count <= count + 1'b1;
			
endmodule