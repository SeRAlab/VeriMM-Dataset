module top_module (
	input [15:0] in,
	output reg out);always_comb begin
		out = ^in; // XOR all bits together
	end
	
endmodule