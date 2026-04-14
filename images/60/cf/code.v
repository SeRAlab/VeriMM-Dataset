module top_module(
	    input [4:0] a,
        input [4:0] b,
        input sel,
        output [4:0] c
	);assign c = sel ? a:b;

endmodule