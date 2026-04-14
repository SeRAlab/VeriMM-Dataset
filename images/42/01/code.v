module top_module(
    input in,
    input [2:0] state,    // 3-bit one-hot current state
    output reg OPEN_next,
    output reg CLOSE_next,
    output reg LOCK_next,
    output reg out
 );parameter OPEN=0, CLOSE=1, LOCK=2;

	assign OPEN_next = state[OPEN]&~in;
	assign CLOSE_next = state[OPEN]&in | state[CLOSE]&in | state[LOCK]&in;
	assign LOCK_next = state[CLOSE]&~in | state[LOCK]&~in;

	assign out = state[CLOSE];

endmodule