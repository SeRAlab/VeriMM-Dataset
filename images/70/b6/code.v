module fsm (
        input [3:1] y,
        input a,
        output reg Y2,
        output reg Y3);

	assign Y2 = y[1]&~a | y[3]&a;
	assign Y3 = y[2]&~a | y[1]&a;

endmodule