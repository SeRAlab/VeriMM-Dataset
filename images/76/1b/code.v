module top_module (
	input [15:0] in,
	input [3:0] shift,
	output reg [15:0] out);always_comb begin
		out = in >> shift;
	end
	
endmodule