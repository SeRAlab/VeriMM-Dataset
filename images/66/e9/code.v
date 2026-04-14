module top_module(
    input in,
    input [2:0] state,    // 3-bit one-hot current state
    output reg WAIT_next,
    output reg PROCESS_next,
    output reg COMPLETE_next,
    output reg out
 );parameter WAIT=0, PROCESS=1, COMPLETE=2;

	assign WAIT_next = state[WAIT]&~in;
	assign PROCESS_next = state[WAIT]&in | state[PROCESS]&in | state[COMPLETE]&in;
	assign COMPLETE_next = state[PROCESS]&~in | state[COMPLETE]&~in;

	assign out = state[PROCESS];

endmodule