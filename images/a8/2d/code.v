module top_module (
        input [3:1] x,
        input t,
        output reg X2,
        output reg X3);

	assign X2 = x[1]&~t | x[3]&t;
	assign X3 = x[1]&t | x[2]&~t;

endmodule