module top_module (
        input [6:1] y,
        input x,
        output reg Y3,
        output reg Y5);

	assign Y3 = y[2]&~x | y[6]&~x;
	assign Y5 = y[3]&~x | y[5]&x;

endmodule