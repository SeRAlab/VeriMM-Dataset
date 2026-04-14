module top_module(
    input in,
    input [2:0] state,    // 3-bit one-hot current state
    output reg J_next,
    output reg K_next,
    output reg L_next,
    output reg out
 );parameter J=0, K=1, L=2;

	assign J_next = state[J]&~in | state[K]&in | state[L]&~in;
	assign K_next = state[J]&in | state[K]&~in;
	assign L_next = state[K]&~in | state[L]&in;

	assign out = state[K];

endmodule