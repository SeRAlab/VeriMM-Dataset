module top_module(
    input in,
    input [2:0] state,    // 3-bit one-hot current state
    output reg S_next,
    output reg T_next,
    output reg U_next,
    output reg out
 );parameter S=0, T=1, U=2;

	assign S_next = state[S]&~in | state[T]&~in | state[U]&in;
	assign T_next = state[S]&in | state[T]&in;
	assign U_next = state[S]&~in | state[U]&~in;

	assign out = state[T] | state[U];

endmodule