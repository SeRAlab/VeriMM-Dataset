module polynomial_evaluator (
    input [3:0] x,
    input [3:0] a0,
    input [3:0] a1,
    input [3:0] a2,
    input [3:0] a3,
    output [15:0] P
);
    wire [15:0] x2, x3, term1, term2, term3, term4;

    assign x2 = x * x;               // x^2
    assign x3 = x2 * x;              // x^3

    assign term1 = {12'b0, a0};       // a0
    assign term2 = a1 * x;            // a1 * x
    assign term3 = a2 * x2;           // a2 * x^2
    assign term4 = a3 * x3;           // a3 * x^3

    assign P = term1 + term2 + term3 + term4; // P(x)
endmodule