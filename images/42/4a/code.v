module state_fsm (
        input [4:1] w,
        input r,
        output reg W2,
        output reg W3);

	assign W2 = w[1]&~r | w[4]&r;
	assign W3 = w[1]&r | w[2]&~r;

endmodule