module top_module (
        input [2:0] d,
        input l,
        output reg D0,
        output reg D1);assign D0 = (d[1] & ~l) | (d[2] & l);
	assign D1 = (d[0] & l) | (d[2] & ~l);

endmodule