module top_module (
	input [7:0] in1,
	input [7:0] in2,
	output reg [7:0] out);always_comb begin
		out = ~(in1 | in2);
	end
	
endmodule