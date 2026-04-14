module top_module (
        input [3:1] h,
        input y,
        output reg H2,
        output reg H3);

	assign H2 = h[1]&~y | h[3]&~y;
	assign H3 = h[1]&y | h[2]&y;

endmodule