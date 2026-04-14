module top_module(
    input in,
    input [3:0] state,    // 4-bit one-hot current state
    output reg S_next,
    output reg T_next,
    output reg U_next,
    output reg V_next,
    output reg out
 );parameter S=0, T=1, U=2, V=3;

	assign S_next = state[S]&in | state[V]&~in;
	assign T_next = state[S]&~in | state[T]&in;
	assign U_next = state[T]&~in | state[U]&in;
	assign V_next = state[U]&~in | state[V]&in;

	assign out = state[S] | state[T];

endmodule