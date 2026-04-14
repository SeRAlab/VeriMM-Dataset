module polynomial_evaluator (
    input [3:0] a0, // Coefficient of x^0
    input [3:0] a1, // Coefficient of x^1
    input [3:0] a2, // Coefficient of x^2
    input [3:0] a3, // Coefficient of x^3
    input [3:0] x,   // Input value of x
    output [15:0] P  // Output polynomial result
);
    wire [15:0] x2, x3;
    wire [15:0] term0, term1, term2, term3;

    assign x2 = x * x;           // x^2
    assign x3 = x2 * x;          // x^3
    
    assign term0 = a0;           // a0
    assign term1 = a1 * x;       // a1 * x
    assign term2 = a2 * x2;      // a2 * x^2
    assign term3 = a3 * x3;      // a3 * x^3

    assign P = term0 + term1 + term2 + term3; // P(x)
endmodule