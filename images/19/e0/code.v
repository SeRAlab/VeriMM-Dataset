module adder32 (
    input [31:0] a,
    input [31:0] b,
    output [31:0] sum,
    output carry_out
);
    assign {carry_out, sum} = a + b;
endmodule