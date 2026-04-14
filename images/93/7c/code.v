module top_module(
    input in,
    input [3:0] state,    // 4-bit one-hot current state
    output reg I_next,
    output reg J_next,
    output reg K_next,
    output reg L_next,
    output reg out
 );parameter I=0, J=1, K=2, L=3;

	assign I_next = state[I]&~in | state[L]&~in;
	assign J_next = state[I]&in | state[J]&in;
	assign K_next = state[J]&~in | state[K]&~in;
	assign L_next = state[K]&in | state[L]&in;

	assign out = state[K] | state[L];

endmodule