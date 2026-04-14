module top_module (
	input [3:0] in0,
	input [3:0] in1,
	output reg [3:0] diff);always_comb begin
		diff = in0 - in1;
	end
	
endmodule