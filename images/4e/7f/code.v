module state_fsm(
    input in,
    input [2:0] state,    // 3-bit one-hot current state
    output reg M_next,
    output reg N_next,
    output reg O_next,
    output reg out
);parameter M=0, N=1, O=2;

	assign M_next = state[M]&~in | state[O]&~in | state[N]&in;
	assign N_next = state[M]&in | state[N]&~in;
	assign O_next = state[M]&in | state[O]&in;

	assign out = state[M] | state[O];

endmodule