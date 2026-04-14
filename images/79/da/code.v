module state_fsm (
        input [3:1] y,
        input h,
        output reg Y2,
        output reg Y3);

	assign Y2 = y[1]&~h | y[3]&h;
	assign Y3 = y[2]&~h | y[1]&h;

endmodule