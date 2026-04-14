module top_module (
        input [3:1] t,
        input f,
        output reg T2,
        output reg T3);

	assign T2 = t[1]&~f | t[3]&f;
	assign T3 = t[2]&~f | t[1]&f;

endmodule