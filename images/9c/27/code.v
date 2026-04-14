module fsm_design (
        input [3:1] y,
        input g,
        output reg Y2,
        output reg Y3);

	assign Y2 = y[1]&~g | y[3]&g;
	assign Y3 = y[2]&~g | y[1]&g;

endmodule