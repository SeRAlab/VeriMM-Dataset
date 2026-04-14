module top_module (
	input clk,
	input start,
	output reg [11:0] count);always @(posedge clk) begin
		if (start)
			count <= count - 1'b1;
	end
	
endmodule