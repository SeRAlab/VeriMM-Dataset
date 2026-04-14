module polynomial_evaluator(
    input signed [7:0] a,
    input signed [7:0] b,
    input signed [7:0] c,
    input [3:0] x,
    output signed [15:0] result
);
    wire signed [15:0] ax2;
    wire signed [15:0] bx;
    assign ax2 = a * x * x; // Calculate a*x^2
    assign bx = b * x;       // Calculate b*x
    assign result = ax2 + bx + c; // P(x) = a*x^2 + b*x + c
endmodule