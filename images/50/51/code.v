module top_module(
	input clk,
	input reset,
	input load,
	input [6:0] load_value,
	output reg [6:0] count);

always @(posedge clk) begin
		if (reset)
			count <= 7'b0000000;
		else if (load)
			count <= load_value;
		else
			count <= count - 1;
	end
	
endmodule