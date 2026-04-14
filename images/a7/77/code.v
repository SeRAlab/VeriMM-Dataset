module top_module(
	input [31:0] input_val, 
	output [31:0] address
);assign address = (input_val - 32'd1024) & (32'b11111111_11111111_11111111_11111100);

endmodule