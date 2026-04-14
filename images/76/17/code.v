module top_module(in1, in2 , out);output [15:0] out;
	input  [15:0] in1, in2;
	wire   [16:0] outTemp;
	assign outTemp = in1 + in2;
	assign out     = outTemp[15:0];
endmodule