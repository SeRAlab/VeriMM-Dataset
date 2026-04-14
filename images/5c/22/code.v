module top_module (
	input [31:0] in,
	output reg [31:0] out);always_comb begin
		out = ~in;
	end
	
endmodule