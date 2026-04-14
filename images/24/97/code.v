module polynomial_evaluation(
    input [7:0] a0, // coefficient a0
    input [7:0] a1, // coefficient a1
    input [7:0] a2, // coefficient a2
    input [7:0] a3, // coefficient a3
    input [7:0] x,   // input value x
    output [15:0] P // output polynomial value
);
    wire [15:0] x2, x3;

    assign x2 = x * x;        // x^2
    assign x3 = x2 * x;      // x^3

    assign P = a0 + 
               a1 * x + 
               a2 * x2 + 
               a3 * x3; // P(x) = a0 + a1*x + a2*x^2 + a3*x^3
endmodule