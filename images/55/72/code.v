module top_module (
        input [3:1] y,
        input u,
        output reg Y2,
        output reg Y3);

	assign Y2 = y[1]&u | y[3]&~u;
	assign Y3 = y[1]&~u | y[2]&u;

endmodule