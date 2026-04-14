module top_module(
    input in,
    input [2:0] state,    // 3-bit one-hot current state
    output reg R_next,
    output reg S_next,
    output reg T_next,
    output reg out
 );parameter R=0, S=1, T=2;

	assign R_next = state[T]&~in;
	assign S_next = state[R]&~in | state[S]&~in;
	assign T_next = state[S]&in | state[T]&in;

	assign out = state[S];

endmodule