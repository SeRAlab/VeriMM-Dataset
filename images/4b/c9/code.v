module fsm_state (
        input [4:1] n,
        input r,
        output reg N2,
        output reg N3);

	assign N2 = n[1]&~r | n[4]&r;
	assign N3 = n[1]&r | n[2]&~r;

endmodule