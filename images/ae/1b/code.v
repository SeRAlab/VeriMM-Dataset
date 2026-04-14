module top_module(in1, in2, sel, out);parameter k = 8;
	input [k-1:0] in1, in2;
	input sel;
	output [k-1:0] out;
	
	assign out = (sel == 1) ? in2 : in1;endmodule