module top_module(
    input clk,
    input reset,
    input [3:0] state,    // 4-bit one-hot current state
    output reg Q0_next,
    output reg Q1_next,
    output reg Q2_next,
    output reg Q3_next,
    output reg out1,
    output reg out2
 );parameter Q0=0, Q1=1, Q2=2, Q3=3;

	assign Q0_next = state[Q1]&clk | state[Q2]&~clk;
	assign Q1_next = state[Q0]&~clk | state[Q3]&clk;
	assign Q2_next = state[Q0]&clk | state[Q3]&~clk;
	assign Q3_next = state[Q1]&~clk | state[Q2]&clk;

	assign out1 = state[Q2] | state[Q3];
	assign out2 = state[Q1] | state[Q3];

endmodule