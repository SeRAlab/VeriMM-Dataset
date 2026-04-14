module polynomial_evaluator (
    input [3:0] a0, // coefficient for x^0
    input [3:0] a1, // coefficient for x^1
    input [3:0] a2, // coefficient for x^2
    input [3:0] a3, // coefficient for x^3
    input [3:0] x,  // input variable
    output [7:0] result // output of the polynomial
);
    wire [7:0] x2, x3;
    assign x2 = x * x;        // x^2
    assign x3 = x2 * x;      // x^3
    assign result = a0 + a1*x + a2*x2 + a3*x3; // P(x)
endmodule