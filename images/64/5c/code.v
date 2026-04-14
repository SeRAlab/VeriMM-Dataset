module top_module(
	input [15:0] i16,
	input EXTsle,
	output [31:0] EXTOUT
    );assign EXTOUT= EXTsle==1? {{16{1'b0}},i16}:{{16{i16[15]}},i16};
	

endmodule