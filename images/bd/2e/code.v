module top_module (
        input [3:1] f,
        input y,
        output reg F2,
        output reg F3);

	assign F2 = f[1]&y | f[3]&~y;
	assign F3 = f[1]&~y | f[2]&y;

endmodule