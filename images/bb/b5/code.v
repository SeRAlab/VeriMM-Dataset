module top_module(
    input start,
    input [2:0] state,    // 3-bit one-hot current state
    output reg Idle_next,
    output reg Processing_next,
    output reg Done_next,
    output reg ready,
    output reg done
 );parameter Idle=0, Processing=1, Done=2;

	assign Idle_next = state[Done]&start | state[Idle]&~start;
	assign Processing_next = state[Idle]&start | state[Processing]&start;
	assign Done_next = state[Processing]&~start | state[Done]&~start;

	assign ready = state[Idle];
	assign done = state[Done];

endmodule