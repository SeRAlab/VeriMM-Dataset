module top_module (
        input [3:1] s,
        input g,
        output reg S2,
        output reg S3);

	assign S2 = s[1]&~g | s[3]&g;
	assign S3 = s[2]&~g | s[1]&g;

endmodule