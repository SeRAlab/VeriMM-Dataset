module state_ctrl (
        input [4:1] v,
        input r,
        output reg V2,
        output reg V3);

	assign V2 = v[1]&~r | v[4]&r;
	assign V3 = v[1]&r | v[2]&~r;

endmodule