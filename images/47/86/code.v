module top_module(
    input in,
    input [2:0] state,    // 3-bit one-hot current state
    output reg A_next,
    output reg B_next,
    output reg C_next,
    output reg out
 );parameter A=0, B=1, C=2;

	assign A_next = state[A]&~in | state[C]&in;
	assign B_next = state[A]&in | state[B]&in;
	assign C_next = state[B]&~in | state[C]&~in;

	assign out = state[B] | state[C];

endmodule