module top_module(
    input in,
    input [2:0] state,    // 3-bit one-hot current state
    output reg READY_next,
    output reg ACTIVE_next,
    output reg DONE_next,
    output reg out
 );parameter READY=0, ACTIVE=1, DONE=2;

	assign READY_next = state[READY]&~in;
	assign ACTIVE_next = state[READY]&in | state[ACTIVE]&in | state[DONE]&in;
	assign DONE_next = state[ACTIVE]&~in | state[DONE]&~in;

	assign out = state[ACTIVE];

endmodule