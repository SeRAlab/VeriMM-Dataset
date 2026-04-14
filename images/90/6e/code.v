module top_module (
	input [63:0] data,
	output [31:0] out_upper,
	output [31:0] out_lower);assign out_upper = data[63:32];
assign out_lower = data[31:0];

endmodule