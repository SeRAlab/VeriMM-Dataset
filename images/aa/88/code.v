module top_module (
        input [4:1] t,
        input v,
        output reg T2,
        output reg T4);

	assign T2 = t[1]&~v | t[4]&~v;
	assign T4 = t[2]&~v | t[3]&v;

endmodule