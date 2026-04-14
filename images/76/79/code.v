module state_machine_fsm (
        input [3:1] y,
        input j,
        output reg Y2,
        output reg Y3);

	assign Y2 = y[1]&~j | y[3]&j;
	assign Y3 = y[2]&~j | y[1]&j;

endmodule