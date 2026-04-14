module top_module (
	input [7:0] in0,
	input [7:0] in1,
	output reg out);always_comb begin
		out = (in0 == in1) ? 1 : 0;
	end
	
endmodule