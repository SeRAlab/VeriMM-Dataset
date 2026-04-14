module top_module(
    input trigger,
    input [1:0] state,    // 2-bit one-hot current state
    output reg Off_next,
    output reg On_next,
    output reg alarm
 );parameter Off=0, On=1;

	assign Off_next = state[On]&~trigger | state[Off]&~trigger;
	assign On_next = state[Off]&trigger | state[On]&trigger;

	assign alarm = state[On];

endmodule