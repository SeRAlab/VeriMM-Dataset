module top_module (
	input clk,
	input reset,
	output reg [5:0] count);always @(posedge clk or posedge reset) begin
		if (reset)
			count <= 6'b000000;
		else
			count <= count + 4;
	end
	
endmodule