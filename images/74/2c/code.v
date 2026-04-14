module top_module (
	input [7:0] in0,
	input [7:0] in1,
	output reg [7:0] out);always_comb begin
		out = in0 & in1;
	end
	
endmodule