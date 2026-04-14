module top_module(
    input [15:0] a,
    input [15:0] b,
    output [15:0] sum,
    output carry
);assign {carry, sum} = a + b; // Simple addition with carry
endmodule