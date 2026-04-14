module top_module (
        input [4:1] s,
        input m,
        output reg S3,
        output reg S4);

	assign S3 = s[2]&~m | s[4]&m;
	assign S4 = s[2]&m | s[1]&~m;

endmodule