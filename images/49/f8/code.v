module top_module (
	input in0,
	input in1,
	output reg out);always_comb begin
		out = ~(in0 | in1);
	end
	
endmodule