module top_module (
        input [4:1] q,
        input p,
        output reg Q3,
        output reg Q4);

	assign Q3 = q[1]&p | q[3]&~p;
	assign Q4 = q[2]&p | q[4]&~p;

endmodule