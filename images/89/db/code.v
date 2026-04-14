module state_fsm_design(
    input in,
    input [2:0] state,    // 3-bit one-hot current state
    output reg T_next,
    output reg U_next,
    output reg V_next,
    output reg out
);parameter T=0, U=1, V=2;

	assign T_next = state[T]&~in | state[V]&~in | state[U]&in;
	assign U_next = state[T]&in | state[U]&~in;
	assign V_next = state[T]&in | state[V]&in;

	assign out = state[T] | state[V];

endmodule