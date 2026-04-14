module top_module (
        input [3:1] p,
        input s,
        output reg P2,
        output reg P3);

	assign P2 = p[1]&~s | p[3]&s;
	assign P3 = p[1]&s | p[2]&~s;

endmodule