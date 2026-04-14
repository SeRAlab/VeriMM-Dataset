module top_module (
        input [4:1] z,
        input u,
        output reg Z2,
        output reg Z3);

	assign Z2 = z[1]&~u | z[4]&u;
	assign Z3 = z[2]&u | z[1]&u;

endmodule