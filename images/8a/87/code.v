module top_module(
    input in,
    input [2:0] state,    // 3-bit one-hot current state
    output reg L_next,
    output reg M_next,
    output reg N_next,
    output reg out
 );parameter L=0, M=1, N=2;

	assign L_next = state[L]&~in | state[M]&in;
	assign M_next = state[L]&in | state[N]&~in;
	assign N_next = state[M]&~in | state[N]&in;

	assign out = state[L] | state[M];

endmodule