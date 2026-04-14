module top_module (
        input [3:1] v,
        input p,
        output reg V2,
        output reg V3);

	assign V2 = v[1]&p | v[3]&~p;
	assign V3 = v[1]&~p | v[2]&p;

endmodule