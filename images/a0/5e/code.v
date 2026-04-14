module top_module(
    input in,
    input [1:0] state,    // 2-bit one-hot current state
    output reg Y_next,
    output reg Z_next,
    output reg out
 );parameter Y=0, Z=1;

	assign Y_next = state[Y]&~in | state[Z]&~in;
	assign Z_next = state[Y]&in | state[Z]&in;

	assign out = (state[Y]&in) | (state[Z]&~in);

endmodule