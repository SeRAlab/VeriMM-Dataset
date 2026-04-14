module top_module(
    input in,
    input [2:0] state,    // 3-bit one-hot current state
    output reg Q0_next,
    output reg Q1_next,
    output reg Q2_next,
    output reg out
 );parameter Q0=0, Q1=1, Q2=2;

	assign Q0_next = state[Q0]&~in;
	assign Q1_next = state[Q0]&in | state[Q1]&in | state[Q2]&in;
	assign Q2_next = state[Q1]&~in | state[Q2]&~in;

	assign out = state[Q1];

endmodule