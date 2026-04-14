module top_module (
        input [3:1] q,
        input i,
        output reg Q2,
        output reg Q3);

	assign Q2 = q[1]&~i | q[3]&i;
	assign Q3 = q[2]&~i | q[1]&i;

endmodule