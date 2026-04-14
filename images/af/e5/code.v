module adder_4bit (
    input [3:0] a,
    input [3:0] b,
    output [3:0] sum,
    output carry_out
);

    // Adder logic
    assign {carry_out, sum} = a + b;

endmodule