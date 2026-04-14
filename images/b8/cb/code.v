module top_module (
        input [3:1] w,
        input q,
        output reg W2,
        output reg W3);

	assign W2 = w[1]&~q | w[3]&q;
	assign W3 = w[1]&q | w[2]&~q;

endmodule