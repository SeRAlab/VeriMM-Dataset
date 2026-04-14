module top_module(src1, src2, out);parameter width = 32;
	input[width-1:0]src1, src2;
	output[width-1:0]out;
	assign out = src1 + src2;
endmodule