module top_module(
    input in,
    input [1:0] state,    // 2-bit one-hot current state
    output reg A_next,
    output reg B_next,
    output reg out
 );parameter A=0, B=1;

	assign A_next = state[A]&~in | state[B]&~in;
	assign B_next = state[A]&in | state[B]&in;

	assign out = (state[A]&in) | (state[B]&~in);

endmodule