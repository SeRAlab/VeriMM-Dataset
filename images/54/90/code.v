module fsm_circuit(
    input in,
    input [2:0] state,    // 3-bit one-hot current state
    output reg U_next,
    output reg V_next,
    output reg W_next,
    output reg out
);parameter U=0, V=1, W=2;

	assign U_next = state[U]&~in;
	assign V_next = state[U]&in | state[V]&in | state[W]&in;
	assign W_next = state[V]&~in | state[W]&~in;

	assign out = state[V];

endmodule