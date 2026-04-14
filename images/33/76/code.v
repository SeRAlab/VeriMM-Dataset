module polynomial_evaluator (
    input [3:0] a0, // Coefficient a0
    input [3:0] a1, // Coefficient a1
    input [3:0] a2, // Coefficient a2
    input [3:0] a3, // Coefficient a3
    input [3:0] x,   // Input x
    output [7:0] P   // Output P(x)
);
    wire [7:0] x1, x2, x3;
    assign x1 = a1 * x;            // a1*x
    assign x2 = a2 * (x * x);      // a2*x^2
    assign x3 = a3 * (x * x * x);  // a3*x^3
    assign P = a0 + x1 + x2 + x3;  // P(x) = a0 + a1*x + a2*x^2 + a3*x^3
endmodule