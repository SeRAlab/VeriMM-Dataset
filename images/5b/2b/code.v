module binary_adder(
    input [3:0] a,
    input [3:0] b,
    output [3:0] sum,
    output carry_out
);

assign {carry_out, sum} = a + b;

endmodule