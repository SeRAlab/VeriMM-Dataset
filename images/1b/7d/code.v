module adder_64bit (
    input [63:0] a,
    input [63:0] b,
    output [63:0] sum,
    output carry_out
);
    assign {carry_out, sum} = a + b;
endmodule