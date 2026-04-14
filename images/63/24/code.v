module full_adder_1bit(
    input a,
    input b,
    input carry_in,
    output sum,
    output carry_out
);

    assign {carry_out, sum} = a + b + carry_in;

endmodule

module top_module(
    input [3:0] a,
    input [3:0] b,
    input carry_in,
    output [3:0] sum,
    output carry_out
);

    wire [2:0] c; // Intermediate carry outputs

    full_adder_1bit fa0(a[0], b[0], carry_in, sum[0], c[0]);
    full_adder_1bit fa1(a[1], b[1], c[0], sum[1], c[1]);
    full_adder_1bit fa2(a[2], b[2], c[1], sum[2], c[2]);
    full_adder_1bit fa3(a[3], b[3], c[2], sum[3], carry_out);

endmodule