module top_module(
    input in,
    input [1:0] state,    // 2-bit one-hot current state
    output reg Idle_next,
    output reg Active_next,
    output reg out
 );parameter Idle=0, Active=1;

	assign Idle_next = state[Active]&~in | state[Idle]&~in;
	assign Active_next = state[Idle]&in | state[Active]&in;

	assign out = state[Active];

endmodule