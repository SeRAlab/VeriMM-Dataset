module top_module(
    input in,
    input [2:0] state,    // 3-bit one-hot current state
    output reg INIT_next,
    output reg EXEC_next,
    output reg FIN_next,
    output reg out
 );parameter INIT=0, EXEC=1, FIN=2;

	assign INIT_next = state[INIT]&~in;
	assign EXEC_next = state[INIT]&in | state[EXEC]&in | state[FIN]&in;
	assign FIN_next = state[EXEC]&~in | state[FIN]&~in;

	assign out = state[EXEC];

endmodule