module top_module (
        input [3:1] z,
        input t,
        output reg Z1,
        output reg Z3);

	assign Z1 = z[3]&~t | z[2]&t;
	assign Z3 = z[1]&t | z[2]&~t;

endmodule