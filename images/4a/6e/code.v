module top_module (
        input [4:1] z,
        input t,
        output reg Z3,
        output reg Z4);

	assign Z3 = z[1]&t | z[4]&~t;
	assign Z4 = z[2]&t | z[3]&~t;

endmodule