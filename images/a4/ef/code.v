module top_module(out, in0, in1, s);output [63:0] out;
	input  [63:0] in0, in1;
	input  s;
	
	assign out = s ? in1 : in0;endmodule