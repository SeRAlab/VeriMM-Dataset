module fsm_design(
    input in,
    input [2:0] state,    // 3-bit one-hot current state
    output reg P_next,
    output reg Q_next,
    output reg R_next,
    output reg out
);parameter P=0, Q=1, R=2;

	assign P_next = state[P]&~in;
	assign Q_next = state[P]&in | state[Q]&in | state[R]&in;
	assign R_next = state[Q]&~in | state[R]&~in;

	assign out = state[Q];

endmodule