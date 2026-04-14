module top_module (
	input [7:0] in,
	input [2:0] shift,
	output reg [7:0] out);always_comb begin
		out = in << shift;
	end
	
endmodule