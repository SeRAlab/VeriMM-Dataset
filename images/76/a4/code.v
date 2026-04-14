module top_module(
    input in,
    input [2:0] state,    // 3-bit one-hot current state
    output reg G_next,
    output reg H_next,
    output reg I_next,
    output reg out
 );parameter G=0, H=1, I=2;

	assign G_next = state[G]&~in | state[I]&~in;
	assign H_next = state[G]&in | state[H]&in;
	assign I_next = state[H]&~in | state[I]&in;

	assign out = state[H] | state[I];

endmodule