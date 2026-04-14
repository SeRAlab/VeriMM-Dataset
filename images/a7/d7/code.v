module top_module(
    input in,
    input [1:0] state,    // 2-bit one-hot current state
    output reg X_next,
    output reg Y_next,
    output reg out
 );parameter X=0, Y=1;

	assign X_next = state[X]&~in | state[Y]&~in;
	assign Y_next = state[X]&in | state[Y]&in;

	assign out = state[Y];

endmodule