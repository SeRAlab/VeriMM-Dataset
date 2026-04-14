module polynomial_evaluator (
    input [3:0] x,        // 4-bit input for x (0 to 15)
    input [7:0] a0,      // Coefficient a0
    input [7:0] a1,      // Coefficient a1
    input [7:0] a2,      // Coefficient a2
    input [7:0] a3,      // Coefficient a3
    input [7:0] a4,      // Coefficient a4
    output [15:0] P      // 16-bit output for polynomial result
);
    wire [15:0] x2, x3, x4;  // Intermediate values for x^2, x^3, x^4
    assign x2 = x * x;       // x^2
    assign x3 = x2 * x;      // x^3
    assign x4 = x3 * x;      // x^4

    assign P = a0 + (a1 * x) + (a2 * x2) + (a3 * x3) + (a4 * x4);
endmodule