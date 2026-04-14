module top_module (
        input [4:1] t,
        input x,
        output reg T3,
        output reg T4);

	assign T3 = t[1]&x | t[3]&~x;
	assign T4 = t[2]&x | t[4]&~x;

endmodule