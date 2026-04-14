module top_module (
        input [4:1] s,
        input r,
        output reg S3,
        output reg S4);

	assign S3 = s[1]&r | s[3]&~r;
	assign S4 = s[2]&r | s[4]&~r;

endmodule