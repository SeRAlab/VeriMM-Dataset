module top_module (
        input [4:1] z,
        input y,
        output reg Z2,
        output reg Z3);

	assign Z2 = z[1]&~y | z[4]&y;
	assign Z3 = z[2]&y | z[1]&y;

endmodule