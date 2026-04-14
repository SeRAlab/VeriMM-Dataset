module top_module(
    input in,
    input [1:0] state,    // 2-bit one-hot current state
    output reg W_next,
    output reg V_next,
    output reg out
 );parameter W=0, V=1;

	assign W_next = state[W]&~in | state[V]&~in;
	assign V_next = state[W]&in | state[V]&in;

	assign out = (state[W]&in) | (state[V]&~in);

endmodule