module top_module (
        input [4:1] z,
        input p,
        output reg Z2,
        output reg Z3);

	assign Z2 = z[1]&~p | z[4]&p;
	assign Z3 = z[2]&p | z[1]&p;

endmodule