module state_logic(
    input in,
    input [2:0] state,    // 3-bit one-hot current state
    output reg D_next,
    output reg E_next,
    output reg F_next,
    output reg out
);parameter D=0, E=1, F=2;

	assign D_next = state[D]&~in | state[F]&~in | state[E]&in;
	assign E_next = state[D]&in | state[E]&~in;
	assign F_next = state[D]&in | state[F]&in;

	assign out = state[D] | state[F];

endmodule