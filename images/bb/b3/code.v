module top_module (
        input [4:1] v,
        input u,
        output reg V3,
        output reg V4);

	assign V3 = v[1]&u | v[3]&~u;
	assign V4 = v[2]&u | v[4]&~u;

endmodule