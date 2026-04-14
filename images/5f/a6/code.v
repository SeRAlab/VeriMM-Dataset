module top_module(
    input in,
    input [2:0] state,    // 3-bit one-hot current state
    output reg IDLE_next,
    output reg RUN_next,
    output reg STOP_next,
    output reg out
 );parameter IDLE=0, RUN=1, STOP=2;

	assign IDLE_next = state[IDLE]&~in;
	assign RUN_next = state[IDLE]&in | state[RUN]&in | state[STOP]&in;
	assign STOP_next = state[RUN]&~in | state[STOP]&~in;

	assign out = state[RUN];

endmodule