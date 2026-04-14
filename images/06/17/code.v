module polynomial_evaluator(
    input signed [7:0] a,
    input signed [7:0] b,
    input signed [7:0] c,
    input signed [7:0] x,
    output signed [15:0] result
);
    wire signed [15:0] x_squared;
    wire signed [15:0] bx;
    
    assign x_squared = a * x * x; // ax^2
    assign bx = b * x;            // bx
    assign result = x_squared + bx + c; // f(x) = ax^2 + bx + c
endmodule