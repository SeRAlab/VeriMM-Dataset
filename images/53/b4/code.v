module top_module (
	input [7:0] in,
	output reg [7:0] out);always_comb begin
		out = in << 1;
	end
	
endmodule