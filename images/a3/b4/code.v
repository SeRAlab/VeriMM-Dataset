module top_module(
    input in,
    input [2:0] state,    // 3-bit one-hot current state
    output reg START_next,
    output reg PROCESS_next,
    output reg END_next,
    output reg out
 );parameter START=0, PROCESS=1, END=2;

	assign START_next = state[START]&~in;
	assign PROCESS_next = state[START]&in | state[PROCESS]&in | state[END]&in;
	assign END_next = state[PROCESS]&~in | state[END]&~in;

	assign out = state[PROCESS];

endmodule