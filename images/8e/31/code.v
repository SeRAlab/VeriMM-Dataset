module top_module (
	input [7:0] in,
	output reg out);always_comb begin
		out = (in[0] + in[1] + in[2] + in[3] + in[4] + in[5] + in[6] + in[7] > 4);
	end
	
endmodule