module top_module (
        input [2:0] v,
        input d,
        output reg V0,
        output reg V1);assign V0 = (v[1] & d) | (v[2] & ~d);
	assign V1 = (v[0] & d) | (v[2] & d);

endmodule