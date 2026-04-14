module polynomial_evaluation (
    input [3:0] a3, a2, a1, a0, // Coefficients of the polynomial
    input [3:0] x,              // Input variable
    output [7:0] P              // Output of the polynomial
);
    wire [7:0] x2, x3, term1, term2, term3, term4;

    assign x2 = x * x;         // x^2
    assign x3 = x2 * x;        // x^3

    assign term1 = a3 * x3;    // a3 * x^3
    assign term2 = a2 * x2;    // a2 * x^2
    assign term3 = a1 * x;      // a1 * x
    assign term4 = a0;          // a0

    assign P = term1 + term2 + term3 + term4; // P(x) = a3*x^3 + a2*x^2 + a1*x + a0
endmodule