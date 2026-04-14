module top_module (
        input [3:1] w,
        input c,
        output reg W2,
        output reg W3);

	assign W2 = w[1]&~c | w[3]&c;
	assign W3 = w[2]&~c | w[1]&c;

endmodule