module top_module (
        input [3:1] f,
        input w,
        output reg F2,
        output reg F3);

	assign F2 = f[1]&~w | f[3]&~w;
	assign F3 = f[1]&w | f[2]&w;

endmodule