module top_module (
	input clk,
	input rst,
	output reg [3:0] count);always @(posedge clk or posedge rst) begin
		if (rst)
			count <= 4'b1111;
		else
			count <= count - 1;
	end
	
endmodule