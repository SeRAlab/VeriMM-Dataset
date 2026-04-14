module fsm_ctrl (
        input [3:1] y,
        input d,
        output reg Y2,
        output reg Y3);

	assign Y2 = y[1]&~d | y[3]&d;
	assign Y3 = y[2]&~d | y[1]&d;

endmodule