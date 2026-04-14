module top_module (
        input [3:1] s,
        input w,
        output reg S2,
        output reg S3);

	assign S2 = s[1]&w | s[3]&~w;
	assign S3 = s[1]&~w | s[2]&w;

endmodule