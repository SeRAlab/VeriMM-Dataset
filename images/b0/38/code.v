module top_module (
        input [4:1] q,
        input n,
        output reg Q3,
        output reg Q4);

	assign Q3 = q[1]&n | q[3]&~n;
	assign Q4 = q[2]&n | q[4]&~n;

endmodule