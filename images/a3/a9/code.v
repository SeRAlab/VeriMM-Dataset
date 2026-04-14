module top_module (
	input [7:0] in1,
	input [7:0] in2,
	input sel,
	output reg [7:0] out);always_comb begin
		out = sel ? in2 : in1;
	end
	
endmodule