module top_module (
        input [3:0] t,
        input b,
        output reg T2,
        output reg T3);assign T2 = (t[1] & b) | (t[3] & b);
	assign T3 = (t[0] & ~b) | (t[2] & b);

endmodule