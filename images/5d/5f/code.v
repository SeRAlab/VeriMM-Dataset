module top_module (
	input [3:0] in0,
	input [3:0] in1,
	input sel,
	output reg [3:0] out);always_comb begin
		out = sel ? in1 : in0;
	end
	
endmodule