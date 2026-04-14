module top_module (
        input [3:1] z,
        input v,
        output reg Z2,
        output reg Z3);

	assign Z2 = z[1]&~v | z[3]&v;
	assign Z3 = z[1]&v | z[2]&~v;

endmodule