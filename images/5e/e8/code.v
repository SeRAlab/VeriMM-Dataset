module top_module (
	input [9:0] d,
	output [9:0] zero_upper,
	output [9:0] flip_lower);assign zero_upper = {5'b00000, d[4:0]};
	assign flip_lower = {d[9:5], ~d[4:0]};
	
endmodule