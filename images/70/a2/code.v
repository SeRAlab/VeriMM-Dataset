module top_module (
        input [4:1] z,
        input q,
        output reg Z2,
        output reg Z3);

	assign Z2 = z[1]&~q | z[4]&q;
	assign Z3 = z[2]&q | z[1]&q;

endmodule