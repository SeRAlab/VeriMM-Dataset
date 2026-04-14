module top_module(gray, bin);parameter SIZE = 4;
	output [SIZE-1:0] gray;
	input [SIZE-1:0] bin;
	assign gray = (bin>>1) ^ bin;

endmodule