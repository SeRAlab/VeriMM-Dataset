module top_module (
	input clk,
	input up_down,
	input reset,
	output reg [3:0] count);always @(posedge clk) begin
		if (reset)
			count <= 4'b0;
		else if (up_down)
			count <= count + 1'b1;
		else
			count <= count - 1'b1;
	end
	
endmodule