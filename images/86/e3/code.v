module top_module(
    input x,
    input rst,
    input [3:0] state,    // 4-bit one-hot current state
    output reg A_next,
    output reg B_next,
    output reg C_next,
    output reg D_next,
    output reg y,
    output reg z
 );parameter A=0, B=1, C=2, D=3;

	assign A_next = state[B]&x | state[D]&~x;
	assign B_next = state[A]&~x | state[D]&x;
	assign C_next = state[A]&x | state[C]&~x;
	assign D_next = state[B]&~x | state[C]&x;

	assign y = state[C];
	assign z = state[D];

endmodule