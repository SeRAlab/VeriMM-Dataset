module top_module(
    input start,
    input stop,
    input [1:0] state,    // 2-bit one-hot current state
    output reg Idle_next,
    output reg Running_next,
    output reg active
 );parameter Idle=0, Running=1;

	assign Idle_next = state[Running]&stop | state[Idle]&~start;
	assign Running_next = state[Idle]&start | state[Running]&~stop;

	assign active = state[Running];

endmodule