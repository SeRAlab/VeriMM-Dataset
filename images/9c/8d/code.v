module top_module (
        input [4:1] y,
        input w,
        output reg Y3,
        output reg Y4);

	assign Y3 = y[1]&w | y[3]&~w;
	assign Y4 = y[2]&w | y[4]&~w;

endmodule