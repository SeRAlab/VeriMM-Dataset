module top_module(
    input in,
    input [2:0] state,    // 3-bit one-hot current state
    output reg ZERO_next,
    output reg ONE_next,
    output reg TWO_next,
    output reg out
 );parameter ZERO=0, ONE=1, TWO=2;

	assign ZERO_next = state[ZERO]&~in | state[TWO]&in;
	assign ONE_next = state[ZERO]&in | state[ONE]&in;
	assign TWO_next = state[ONE]&~in | state[TWO]&~in;

	assign out = state[ONE];

endmodule