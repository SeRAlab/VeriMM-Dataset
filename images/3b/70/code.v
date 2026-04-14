module polynomial_evaluator (
    input [7:0] x,
    input [15:0] a0,
    input [15:0] a1,
    input [15:0] a2,
    input [15:0] a3,
    output [15:0] result
);
    wire [15:0] x1, x2, x3;
    wire [15:0] term1, term2, term3;

    assign x1 = a1 * x;              // a1 * x
    assign x2 = x * x;               // x^2
    assign term2 = a2 * x2;          // a2 * x^2
    assign x3 = x2 * x;              // x^3
    assign term3 = a3 * x3;          // a3 * x^3

    assign result = a0 + x1 + term2 + term3; // P(x) = a0 + a1*x + a2*x^2 + a3*x^3
endmodule