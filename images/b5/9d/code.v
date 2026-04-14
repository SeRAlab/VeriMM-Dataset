module top_module(
    input in,
    input [1:0] state,    // 2-bit one-hot current state
    output reg U_next,
    output reg T_next,
    output reg out
 );parameter U=0, T=1;

	assign U_next = state[U]&~in | state[T]&~in;
	assign T_next = state[U]&in | state[T]&in;

	assign out = (state[U]&in) | (state[T]&~in);

endmodule