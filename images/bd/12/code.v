module top_module(
    input in,
    input [3:0] state,    // 4-bit one-hot current state
    output reg W_next,
    output reg X_next,
    output reg Y_next,
    output reg Z_next,
    output reg out
 );parameter W=0, X=1, Y=2, Z=3;

	assign W_next = state[W]&~in | state[Z]&~in;
	assign X_next = state[W]&in | state[X]&in | state[Z]&in;
	assign Y_next = state[X]&~in | state[Y]&in;
	assign Z_next = state[Y]&~in;

	assign out = state[X] | state[Y];

endmodule