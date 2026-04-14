module top_module(
    input in,
    input [1:0] state,    // 2-bit one-hot current state
    output reg Start_next,
    output reg Finish_next,
    output reg out
 );parameter Start=0, Finish=1;

	assign Start_next = state[Start]&~in | state[Finish]&~in;
	assign Finish_next = state[Start]&in | state[Finish]&in;

	assign out = state[Finish];

endmodule