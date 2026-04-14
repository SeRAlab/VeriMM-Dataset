module state_transition (
        input [4:1] p,
        input r,
        output reg P2,
        output reg P3);

	assign P2 = p[1]&~r | p[4]&r;
	assign P3 = p[1]&r | p[2]&~r;

endmodule