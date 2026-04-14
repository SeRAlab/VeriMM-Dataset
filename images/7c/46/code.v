module top_module (
        input [3:1] v,
        input d,
        output reg V2,
        output reg V3);

	assign V2 = v[1]&~d | v[3]&d;
	assign V3 = v[2]&~d | v[1]&d;

endmodule