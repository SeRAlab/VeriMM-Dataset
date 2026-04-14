module top_module(
    input in,
    input [2:0] state,    // 3-bit one-hot current state
    output reg R0_next,
    output reg R1_next,
    output reg R2_next,
    output reg out
 );parameter R0=0, R1=1, R2=2;

	assign R0_next = state[R0]&~in;
	assign R1_next = state[R0]&in | state[R1]&in | state[R2]&in;
	assign R2_next = state[R1]&~in | state[R2]&~in;

	assign out = state[R1];

endmodule