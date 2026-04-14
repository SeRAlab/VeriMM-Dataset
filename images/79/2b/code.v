module top_module (
        input [4:1] z,
        input w,
        output reg Z2,
        output reg Z3);

	assign Z2 = z[1]&~w | z[4]&w;
	assign Z3 = z[2]&w | z[1]&w;

endmodule