module polynomial_evaluator(
    input [3:0] a, // Coefficient for x^2
    input [3:0] b, // Coefficient for x
    input [3:0] c, // Constant term
    input [3:0] x, // Input value
    output [7:0] result // Result of polynomial evaluation
);
    wire [7:0] x_squared;
    wire [7:0] bx;
    assign x_squared = a * x * x; // a*x^2
    assign bx = b * x; // b*x
    assign result = x_squared + bx + c; // P(x) = a*x^2 + b*x + c
endmodule