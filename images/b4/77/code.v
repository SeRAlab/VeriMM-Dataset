module top_module (
	input [3:0] in0,
	input [3:0] in1,
	output reg [3:0] xnor_out);always_comb begin
		xnor_out = ~(in0 ^ in1);
	end
	
endmodule