module top_module (
	input clk,
	input reset,
	input enable,
	output reg [11:0] count);always @(posedge clk or posedge reset) begin
		if (reset)
			count <= 12'b000000000000;
		else if (enable)
			count <= count + 1;
	end
	
endmodule