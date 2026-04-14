module top_module (
        input [4:1] x,
        input q,
        output reg X3,
        output reg X4);

	assign X3 = x[1]&q | x[3]&~q;
	assign X4 = x[2]&q | x[4]&~q;

endmodule