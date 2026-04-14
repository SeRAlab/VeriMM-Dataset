module polynomial_evaluator (
    input [3:0] a,   // coefficient of x^4
    input [3:0] b,   // coefficient of x^3
    input [3:0] c,   // coefficient of x^2
    input [3:0] d,   // coefficient of x
    input [3:0] e,   // constant term
    input [3:0] x,   // input variable
    output [15:0] result // polynomial result output
);

wire [15:0] x2, x3, x4; // intermediate wires for powers of x
assign x2 = x * x;            // x^2
assign x3 = x2 * x;          // x^3
assign x4 = x3 * x;          // x^4

assign result = (a * x4) + (b * x3) + (c * x2) + (d * x) + e; // polynomial evaluation

endmodule