module top_module(
    input signal,
    input [2:0] state,    // 3-bit one-hot current state
    output reg S0_next,
    output reg S1_next,
    output reg S2_next,
    output reg detected
 );parameter S0=0, S1=1, S2=2;

	assign S0_next = state[S0]&~signal | state[S1]&signal;
	assign S1_next = state[S0]&signal | state[S2]&~signal;
	assign S2_next = state[S1]&~signal | state[S2]&signal;

	assign detected = state[S2];

endmodule