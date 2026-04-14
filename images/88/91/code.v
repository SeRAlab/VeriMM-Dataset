module fsm_control (
        input [3:1] y,
        input f,
        output reg Y2,
        output reg Y3);

	assign Y2 = y[1]&~f | y[3]&f;
	assign Y3 = y[2]&~f | y[1]&f;

endmodule