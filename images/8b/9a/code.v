module top_module (
        input [3:1] p,
        input j,
        output reg P2,
        output reg P3);

	assign P2 = p[1]&~j | p[3]&j;
	assign P3 = p[2]&~j | p[1]&j;

endmodule