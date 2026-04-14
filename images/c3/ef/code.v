module adder_subtractor(
    input [3:0] A,
    input [3:0] B,
    input SUB,
    output [3:0] OUT
);

    wire [3:0] negB;
    assign negB = ~B + 1;

    assign OUT = (SUB) ? A + negB : A + B;

endmodule