module top_module(
	gray,
	channels
    );parameter color_width = 8;
	parameter color_channels = 3; 

	input[color_width - 1 : 0] gray;
	output[color_channels * color_width - 1 : 0] channels;

	genvar i;
	generate
		`define h (i + 1) * color_width - 1
		`define l i * color_width
		for (i = 0; i < color_channels; i = i + 1) begin: channel
			assign channels[`h : `l] = gray;
		end
		`undef h
		`undef l

	endgenerate

endmodule