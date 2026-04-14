module top_module (
	input [1:0] in0,
	input [1:0] in1,
	output reg [1:0] out);always_comb begin
		out = ~(in0 & in1);
	end
	
endmodule