module top_module (
        input [3:1] y,
        input b,
        output reg Y2,
        output reg Y3);

	assign Y2 = y[1]&~b | y[3]&b;
	assign Y3 = y[2]&~b | y[1]&b;

endmodule