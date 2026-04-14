module top_module (
	input [7:0] in,
	output reg [15:0] out);always_comb begin
		out = {8'b0, in};
	end
	
endmodule