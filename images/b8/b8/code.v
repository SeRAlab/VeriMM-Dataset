module top_module(
    input in,
    input [2:0] state,    // 3-bit one-hot current state
    output reg X0_next,
    output reg X1_next,
    output reg X2_next,
    output reg out
 );parameter X0=0, X1=1, X2=2;

	assign X0_next = state[X0]&~in;
	assign X1_next = state[X0]&in | state[X1]&in | state[X2]&in;
	assign X2_next = state[X1]&~in | state[X2]&~in;

	assign out = state[X1];

endmodule