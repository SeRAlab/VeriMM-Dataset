module fsm (
        input [4:1] t,
        input r,
        output reg T2,
        output reg T3);

	assign T2 = t[1]&~r | t[4]&r;
	assign T3 = t[1]&r | t[2]&~r;

endmodule