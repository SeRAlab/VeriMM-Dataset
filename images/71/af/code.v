module top_module(
    input in,
    input [2:0] state,    // 3-bit one-hot current state
    output reg W_next,
    output reg X_next,
    output reg Y_next,
    output reg out
 );parameter W=0, X=1, Y=2;

	assign W_next = state[W]&~in | state[Y]&in;
	assign X_next = state[W]&in | state[X]&in | state[Y]&~in;
	assign Y_next = state[X]&~in;

	assign out = state[W] | state[Y];

endmodule