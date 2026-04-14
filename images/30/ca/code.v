module adder_16bit(
    input [15:0] a,
    input [15:0] b,
    output [15:0] sum,
    output carry_out
);
    assign {carry_out, sum} = a + b;
endmodule