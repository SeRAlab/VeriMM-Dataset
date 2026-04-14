module adder_8bit (
    input [7:0] a,
    input [7:0] b,
    output [7:0] sum,
    output carry_out
);

    assign {carry_out, sum} = a + b;
endmodule