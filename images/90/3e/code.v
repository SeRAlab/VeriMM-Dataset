module top_module (
        input [2:0] x,
        input f,
        output reg X0,
        output reg X1);assign X0 = (x[1] & ~f) | (x[2] & f);
	assign X1 = (x[0] & f) | (x[2] & ~f);

endmodule