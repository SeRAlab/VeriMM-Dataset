module top_module(
    input in,
    input [1:0] state,    // 2-bit one-hot current state
    output reg G_next,
    output reg H_next,
    output reg out
 );parameter G=0, H=1;

	assign G_next = state[G]&in | state[H]&in;
	assign H_next = state[G]&~in | state[H]&~in;

	assign out = state[G];

endmodule