module top_module(
    input [31:0] a,
    input [31:0] b,
    input sub,
    output reg [31:0] sum,
    output carry_out
);wire [31:0] b_neg;
    wire carry_out_add;
    wire carry_out_sub;
    wire carry_in;

    assign carry_in = sub;

    // Calculate negative of b for subtraction
    assign b_neg = b ^ {32{sub}}; // XOR B with all 1s when sub is 1

    // 32-bit adder
    wire [31:0] sum_internal;
    wire carry_internal;

    assign {carry_internal, sum_internal} = a + b_neg + carry_in;

    assign sum = sum_internal;
    assign carry_out = carry_internal;

endmodule