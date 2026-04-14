module top_module(
    input in,
    input [2:0] state,    // 3-bit one-hot current state
    output reg P0_next,
    output reg P1_next,
    output reg P2_next,
    output reg out
 );parameter P0=0, P1=1, P2=2;

	assign P0_next = state[P0]&~in;
	assign P1_next = state[P0]&in | state[P1]&in | state[P2]&in;
	assign P2_next = state[P1]&~in | state[P2]&~in;

	assign out = state[P1];

endmodule