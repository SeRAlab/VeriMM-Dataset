module top_module (
        input [3:1] l,
        input p,
        output reg L2,
        output reg L3);

	assign L2 = l[1]&~p | l[3]&~p;
	assign L3 = l[1]&p | l[2]&p;

endmodule