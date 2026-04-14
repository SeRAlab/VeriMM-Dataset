module top_module (
	input clk,
	input reset,
	output reg [15:0] count);always @(posedge clk or posedge reset) begin
		if (reset)
			count <= 16'b0000000000000000;
		else
			count <= count - 4;
	end
	
endmodule