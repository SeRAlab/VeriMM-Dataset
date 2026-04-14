module top_module(
    input in,
    input [1:0] state,    // 2-bit one-hot current state
    output reg P_next,
    output reg Q_next,
    output reg out
 );parameter P=0, Q=1;

	assign P_next = state[P]&~in | state[Q]&~in;
	assign Q_next = state[P]&in | state[Q]&in;

	assign out = state[Q];

endmodule