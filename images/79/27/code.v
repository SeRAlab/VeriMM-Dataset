module top_module (
        input [2:0] s,
        input a,
        output reg S1,
        output reg S2);assign S1 = (s[0] & a) | (s[2] & ~a);
	assign S2 = (s[1] & a) | (s[0] & ~a);

endmodule