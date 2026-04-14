module top_module (
        input [2:0] u,
        input c,
        output reg U0,
        output reg U1);assign U0 = (u[1] & c) | (u[2] & ~c);
	assign U1 = (u[0] & ~c) | (u[2] & c);

endmodule