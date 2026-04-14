module top_module (
	input [3:0] in,
	output reg [3:0] out);always_comb begin
		out = in - 1;
	end
	
endmodule