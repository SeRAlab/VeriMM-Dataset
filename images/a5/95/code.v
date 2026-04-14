module top_module(
	input clk,
	input reset,
	input [7:0] in,
	output reg [3:0] count);integer i;
			
	always @(posedge clk or posedge reset) begin
		if (reset)
			count <= 0;
		else begin
			count <= 0;
			for (i = 0; i < 8; i = i + 1)
				count <= count + in[i];
		end
	end
	
endmodule