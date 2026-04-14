module polynomial_evaluator (
    input [3:0] a0, // Coefficient a0
    input [3:0] a1, // Coefficient a1
    input [3:0] a2, // Coefficient a2
    input [3:0] a3, // Coefficient a3
    input [3:0] x,   // Input value x
    output [7:0] P   // Output value P(x)
);
    wire [7:0] x2, x3, term1, term2, term3;

    assign x2 = x * x;        // x^2
    assign x3 = x * x2;       // x^3

    assign term1 = a0;        // a0
    assign term2 = a1 * x;    // a1 * x
    assign term3 = a2 * x2;   // a2 * x^2

    assign P = term1 + term2 + term3 + (a3 * x3); // P(x) = a0 + a1*x + a2*x^2 + a3*x^3
endmodule