module top_module (
        input [4:1] z,
        input r,
        output reg Z2,
        output reg Z3);

	assign Z2 = z[1]&~r | z[4]&r;
	assign Z3 = z[2]&r | z[1]&r;

endmodule