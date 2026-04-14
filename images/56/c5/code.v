module top_module(
    input [3:0] a,
    input [3:0] b,
    input sub,
    output [3:0] sum
);wire [3:0] neg_b;
    assign neg_b = ~b + 1; // Two's complement negation of b

    assign sum = sub ? a + neg_b : a + b; // Ternary operator to choose between addition and subtraction

endmodule