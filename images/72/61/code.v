module top_module(
    input clk,
    input reset,
    input signed [7:0] in1,
    input signed [7:0] in2,
    output signed [15:0] out
);assign out = in1 * in2;

endmodule