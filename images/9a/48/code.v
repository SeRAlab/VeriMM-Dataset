module zero_detector(
	input [15:0] in,
	output out);assign out = (in == 16'b0);
endmodule