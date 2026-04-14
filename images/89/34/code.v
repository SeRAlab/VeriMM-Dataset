module state_machine (
        input [4:1] s,
        input r,
        output reg S2,
        output reg S3);

	assign S2 = s[1]&~r | s[4]&r;
	assign S3 = s[1]&r | s[2]&~r;

endmodule