module top_module(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    input Op,
    output [3:0] Sum,
    output Cout
);wire [3:0] B_neg;

    // Two's complement negation of B
    assign B_neg = ~B + 1;

    // Calculation of sum and carry out based on Op and Cin
    assign {Cout, Sum} = (Op == 0) ? A + B + Cin : A + B_neg + Cin;

endmodule