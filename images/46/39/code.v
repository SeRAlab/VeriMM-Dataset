module top_module(
    input in,
    input [2:0] state,    // 3-bit one-hot current state
    output reg S0_next,
    output reg S1_next,
    output reg S2_next,
    output reg out
 );parameter S0=0, S1=1, S2=2;

	assign S0_next = state[S0]&~in | state[S2]&in;
	assign S1_next = state[S0]&in | state[S1]&in;
	assign S2_next = state[S1]&~in | state[S2]&~in;

	assign out = state[S1];

endmodule