module polynomial_evaluator (
    input signed [7:0] a, // coefficient of x^2
    input signed [7:0] b, // coefficient of x
    input signed [7:0] c, // constant term
    input signed [7:0] x, // input value
    output signed [15:0] result // result of P(x)
);
    wire signed [15:0] x_squared;
    wire signed [15:0] ax_squared;
    wire signed [15:0] bx;
    
    assign x_squared = x * x; // x^2
    assign ax_squared = a * x_squared; // a * x^2
    assign bx = b * x; // b * x
    assign result = ax_squared + bx + c; // P(x) = a*x^2 + b*x + c
endmodule