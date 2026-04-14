module top_module (
        input [4:1] z,
        input x,
        output reg Z2,
        output reg Z3);

	assign Z2 = z[1]&~x | z[4]&x;
	assign Z3 = z[2]&x | z[1]&x;

endmodule