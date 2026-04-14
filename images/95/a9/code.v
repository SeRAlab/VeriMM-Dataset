module state_logic (
        input [4:1] q,
        input r,
        output reg Q2,
        output reg Q3);

	assign Q2 = q[1]&~r | q[4]&r;
	assign Q3 = q[1]&r | q[2]&~r;

endmodule