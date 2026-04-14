module state_control(
    input in,
    input [2:0] state,    // 3-bit one-hot current state
    output reg K_next,
    output reg L_next,
    output reg M_next,
    output reg out
);parameter K=0, L=1, M=2;

	assign K_next = state[K]&~in;
	assign L_next = state[K]&in | state[L]&in | state[M]&in;
	assign M_next = state[L]&~in | state[M]&~in;

	assign out = state[L];

endmodule