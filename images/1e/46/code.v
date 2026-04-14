module polynomial_evaluation (
    input [3:0] a, // Coefficient a
    input [3:0] b, // Coefficient b
    input [3:0] c, // Coefficient c
    input [3:0] x, // Input x
    output [7:0] result // Result of P(x)
);
    wire [7:0] x_squared;
    wire [7:0] ax_squared;
    wire [7:0] bx;
    
    assign x_squared = x * x;         // x^2
    assign ax_squared = a * x_squared; // ax^2
    assign bx = b * x;                 // bx
    assign result = ax_squared + bx + c; // P(x) = ax^2 + bx + c
endmodule