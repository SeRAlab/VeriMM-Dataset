module top_module(out, a, b);output [7:0] out;
	input  [7:0] a;
	input  [7:0] b;
        wire  [15:0] out1;
	assign out1 = a * b;
        assign out=out1[11:4];
endmodule