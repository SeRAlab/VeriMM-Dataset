module state_fsm (
        input [4:1] m,
        input r,
        output reg M2,
        output reg M3);

	assign M2 = m[1]&~r | m[4]&r;
	assign M3 = m[1]&r | m[2]&~r;

endmodule