module top_module (
	input clk,
	input reset,
	input up,
	input down,
	output reg [15:0] count);always @(posedge clk or posedge reset) begin
		if (reset)
			count <= 16'b0000000000000000;
		else if (up)
			count <= count + 1;
		else if (down)
			count <= count - 1;
	end
	
endmodule