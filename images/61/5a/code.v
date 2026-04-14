module top_module(
    input in,
    input [2:0] state,    // 3-bit one-hot current state
    output reg X_next,
    output reg Y_next,
    output reg Z_next,
    output reg out
 );parameter X=0, Y=1, Z=2;

	assign X_next = state[Y]&in;
	assign Y_next = state[X]&in | state[Z]&in;
	assign Z_next = state[Y]&~in | state[Z]&~in;

	assign out = state[Y] | state[Z];

endmodule