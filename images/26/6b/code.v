module polynomial_evaluator(
    input signed [7:0] a,      // Coefficient a
    input signed [7:0] b,      // Coefficient b
    input signed [7:0] c,      // Coefficient c
    input signed [7:0] x,      // Input value
    output signed [15:0] result // Result of polynomial evaluation
);
    wire signed [15:0] x_squared = x * x; // x^2
    wire signed [15:0] ax_squared = a * x_squared; // ax^2
    wire signed [15:0] bx = b * x; // bx
    assign result = ax_squared + bx + c; // P(x) = ax^2 + bx + c
endmodule