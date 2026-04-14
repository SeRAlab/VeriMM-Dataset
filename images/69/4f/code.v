module top_module(
    input in,
    input [1:0] state,    // 2-bit one-hot current state
    output reg S0_next,
    output reg S1_next,
    output reg out
 );parameter S0=0, S1=1;

	assign S0_next = state[S0]&~in | state[S1]&~in;
	assign S1_next = state[S0]&in | state[S1]&in;

	assign out = state[S1];

endmodule