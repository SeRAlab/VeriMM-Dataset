module top_module (
        input [3:1] b,
        input t,
        output reg B2,
        output reg B3);

	assign B2 = b[1]&~t | b[3]&~t;
	assign B3 = b[1]&t | b[2]&t;

endmodule