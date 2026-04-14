module top_module(
	b,
	channels
    );parameter color_width = 8;
	parameter color_channels = 3;

	input b;
	output[color_channels * color_width - 1 : 0] channels;

	genvar i;
	generate
		`define h (i + 1) * color_width - 1
		`define l i * color_width
		for (i = 0; i < color_channels; i = i + 1) begin: channel
			assign channels[`h : `l] = b ? {color_width{1'b1}} : {color_width{1'b0}};
		end
		`undef h
		`undef l

	endgenerate

endmodule