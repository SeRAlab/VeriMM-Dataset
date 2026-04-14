module state_machine_control (
        input [3:1] y,
        input e,
        output reg Y2,
        output reg Y3);

	assign Y2 = y[1]&~e | y[3]&e;
	assign Y3 = y[2]&~e | y[1]&e;

endmodule