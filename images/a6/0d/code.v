module top_module(
    input in,
    input [1:0] state,    // 2-bit one-hot current state
    output reg Off_next,
    output reg On_next,
    output reg out
 );parameter Off=0, On=1;

	assign Off_next = state[Off]&~in | state[On]&~in;
	assign On_next = state[Off]&in | state[On]&in;

	assign out = state[On];

endmodule