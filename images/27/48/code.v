module polynomial_evaluator (
    input [7:0] x,            // Input value for x
    input [7:0] a4, a3, a2, a1, a0, // Coefficients for the polynomial
    output [15:0] result      // Result of the polynomial evaluation
);
    wire [15:0] x2, x3, x4;
    wire [15:0] ax4, ax3, ax2, ax1, ax0;

    assign x2 = x * x;                 // x^2
    assign x3 = x2 * x;                // x^3
    assign x4 = x3 * x;                // x^4

    assign ax4 = a4 * x4;              // a4 * x^4
    assign ax3 = a3 * x3;              // a3 * x^3
    assign ax2 = a2 * x2;              // a2 * x^2
    assign ax1 = a1 * x;                // a1 * x
    assign ax0 = a0;                   // a0

    assign result = ax4 + ax3 + ax2 + ax1 + ax0; // Final result
endmodule