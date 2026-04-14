module state_ctrl (
        input [3:1] y,
        input c,
        output reg Y2,
        output reg Y3);

	assign Y2 = y[1]&~c | y[3]&c;
	assign Y3 = y[2]&~c | y[1]&c;

endmodule