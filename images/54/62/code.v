module top_module(input clk, input rst, output reg [3:0] count);always @(posedge clk or negedge rst)
		if (!rst)
			count <= 4'b0;
		else
			count <= count + 1;

endmodule