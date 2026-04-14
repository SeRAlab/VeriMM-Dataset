module top_module(in1, in2, out, select);parameter size = 1;
	input[size-1:0] in1, in2;
	output[size-1:0] out;
	input select;
	assign out = select? in2 : in1;
endmodule