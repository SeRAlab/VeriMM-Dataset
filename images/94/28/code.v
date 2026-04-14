module top_module(
    input in,
    input [2:0] state,    // 3-bit one-hot current state
    output reg E_next,
    output reg F_next,
    output reg G_next,
    output reg out
 );parameter E=0, F=1, G=2;

	assign E_next = state[E]&~in | state[F]&in;
	assign F_next = state[E]&in | state[G]&~in;
	assign G_next = state[F]&~in | state[G]&in;

	assign out = state[E] | state[F];

endmodule