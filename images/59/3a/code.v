module top_module(
	input[23:0] rgb24,
	output[15:0] vga
    );assign vga[15:11] = rgb24[23:19];
	assign vga[10:5] = rgb24[15:10];
	assign vga[4:0] = rgb24[7:3];

endmodule