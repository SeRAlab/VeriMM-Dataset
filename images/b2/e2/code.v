module top_module (
        input [4:1] z,
        input s,
        output reg Z2,
        output reg Z3);

	assign Z2 = z[1]&~s | z[4]&s;
	assign Z3 = z[2]&s | z[1]&s;

endmodule