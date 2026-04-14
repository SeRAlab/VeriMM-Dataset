module top_module(
    input a,
    input [2:0] state,    // 3-bit one-hot current state
    output reg X_next,
    output reg Y_next,
    output reg Z_next,
    output reg b,
    output reg c
 );parameter X=0, Y=1, Z=2;

	assign X_next = state[Y]&a | state[Z]&~a;
	assign Y_next = state[X]&~a | state[Z]&a;
	assign Z_next = state[X]&a | state[Y]&~a;

	assign b = state[Y];
	assign c = state[Z];

endmodule