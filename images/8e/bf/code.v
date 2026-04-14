module top_module(
	input clk,
	input clear,
	input enable,
	output reg [3:0] count);

always @(posedge clk or posedge clear) begin
		if (clear)
			count <= 4'b0000;
		else if (enable)
			count <= count + 1;
	end
	
endmodule