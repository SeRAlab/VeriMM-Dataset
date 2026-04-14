module state_machine (
        input [3:1] y,
        input x,
        output reg Y2,
        output reg Y3);

	assign Y2 = y[1]&~x | y[3]&x;
	assign Y3 = y[2]&~x | y[1]&x;

endmodule